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

    ALLOWED_USER_ATTRIBUTES = %w[
      id
      firebase_id
      display_name
      email
      email_verified
      policy_accepted
    ].freeze

    def sign_in_with_token(token)
      payload = firebase_auth_service.verify_and_get_token_payload(token)

      user = create_or_fetch_authed_user payload

      # Only actually sign user in if email is verified
      if !user.policy_accepted
        session[:user] = user.id
      elsif user.email_verified
        session[:user] = user.id
        flash[:notice] = 'You are now signed in'
      else
        session[:user] = nil
        flash[:alert] = 'Cannot sign you in just yet - please verify your account by clicking on the link in the verification email sent to you'
      end

      {
        user: user.attributes.slice(*ALLOWED_USER_ATTRIBUTES),
        forwarding_url: session.delete(:forwarding_url) || root_path
      }
    end

    def accept_user_policy
      return unless current_user?
      user = current_user
      user.policy_accepted = true
      user.save
      
      {
        policy_accepted: user.policy_accepted
      }
    end

    def sign_out_current_user
      session[:user] = nil
      flash[:notice] = 'You have been signed out'
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
  end
end
