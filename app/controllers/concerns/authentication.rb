module Authentication
  extend ActiveSupport::Concern
  extend Memoist

  class_methods do
    def with_auth_session_management
      include SessionManagement
    end
  end

  included do
    helper_method :current_user?
    helper_method :current_user
  end

  def require_authentication
    session.delete(:forwarding_url) if session.key?(:forwarding_url)

    return if current_user?


    # Will only remember course_id and forwarding_url for users that are authenticated.
    # Will only remember course_id when the request contains a course_id such
    # as the subscription new/edit route.
    session[:last_course_id] = params[:course_id] if params.key?(:course_id)
    session[:forwarding_url] = request.original_url if request.get?

    flash[:alert] = 'Please sign in to continue'
    redirect_to auth_sign_in_path
  end

  def current_user?
    current_user.present?
  end

  def current_user
    return nil unless session[:user]

    User
      .find(session[:user])
      .tap do |u|
        u.touch(:last_seen_at) # rubocop:disable Rails/SkipsModelValidations
      end
  end
  memoize :current_user

  module SessionManagement
    extend Memoist

    def sign_in_with_token(token, terms_accepted: nil)
      payload = firebase_auth_service.verify_and_get_token_payload(token)

      user = create_or_fetch_authed_user payload

      user.update!(terms_accepted: terms_accepted) unless terms_accepted.nil?

      # Only actually sign user in on the server if both are true:
      # - terms have been accepted
      # - email is verified
      if !user.terms_accepted
        session[:user] = nil
        forwarding_url = session[:forwarding_url]
        last_course_id = session[:last_course_id]

      elsif !user.email_verified
        session[:user] = nil

        # Delete forwarding URL so we always end up back at the homepage
        session.delete(:forwarding_url)
        forwarding_url = root_path_with_params
        last_course_id = session.delete(:last_course_id)

      else
        session[:user] = user.id
        forwarding_url = session.delete(:forwarding_url) || root_path_with_params
        last_course_id = session.delete(:last_course_id)
      end

      {
        user: ActiveModelSerializers::SerializableResource.new(user).as_json,
        forwarding_url: forwarding_url,
        last_course_id: last_course_id
      }
    end

    def sign_out_current_user(message = nil)
      session[:user] = nil

      flash_message = [
        'You have been signed out',
        (". #{message}" if message.present?)
      ].compact.join(' ')
      flash[:notice] = flash_message
    end

    private

    def firebase_auth_service
      FirebaseAuthService.new(FirebaseConfig.project_id)
    end
    memoize :firebase_auth_service

    def create_or_fetch_authed_user(auth_data)
      User.transaction do
        User
          .where(firebase_id: auth_data['user_id'])
          .first_or_initialize
          .tap do |u|
            u.display_name = auth_data['name']
            u.email = auth_data['email']
            u.email_verified = auth_data['email_verified']
            u.save!
          end
      end
    end

    def root_path_with_params
      root_path(last_course_id: session[:last_course_id], just_signed_in: !session[:user].nil? ? true : nil)
    end
  end
end
