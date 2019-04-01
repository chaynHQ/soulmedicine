class SubscriptionsController < ApplicationController
  before_action :require_authentication, except: %i[unsubscribe]

  before_action :find_or_initialize_subscription, only: %i[show update destroy pause unpause]

  # GET /subscriptions
  def index
    @subscriptions = current_user.subscriptions
  end

  # GET /pathways/:course_id/subscription
  def show; end

  # PUT /pathways/:course_id/subscription
  def update
    params = subscription_params

    # Remove blank values
    params[:other_languages].reject!(&:blank?) if params.key?(:other_languages)
    params[:days].reject!(&:blank?) if params.key?(:days)

    utc_schedule = TimeZoneScheduleConverter.convert(
      from_zone: params[:user_timezone],
      to_zone: 'UTC',
      days: params[:days],
      hour: params[:hour].presence&.to_i
    )

    @subscription.days_utc = utc_schedule[:days]
    @subscription.hours_utc = [utc_schedule[:hour]]

    if @subscription.update(params.except(:days, :hour))
      redirect_to course_path(@subscription.course), notice: 'Subscription was successfully updated.'
    else
      render :show # We expect the `show` view to render the form
    end
  end

  # DELETE /pathways/:course_id/subscription
  def destroy
    @subscription.destroy if @subscription.persisted?
    redirect_to subscriptions_url, notice: 'Subscription was successfully cancelled.'
  end

  # PATCH /pathways/:course_id/subscription/pause
  def pause
    @subscription.pause!

    redirect_to subscriptions_url, notice: 'Subscription paused.'
  end

  # PATCH /pathways/:course_id/subscription/unpause
  def unpause
    @subscription.unpause!

    redirect_to subscriptions_url, notice: 'Subscription activated.'
  end

  # GET /pathways/:course_id/subscription/unsubscribe/:user_id
  def unsubscribe
    redirect_path = root_path

    user = SignedGlobalID.find(params[:user_id], for: :unsubscribe_course)
    if user
      subscription = user.subscriptions.find_by(course_slug: params[:course_id])
      subscription&.pause!

      redirect_path = subscriptions_path if current_user
    end

    redirect_to redirect_path, notice: 'Subscription paused.'
  end

  private

  def find_or_initialize_subscription
    course_slug = params[:course_id]

    @subscription = current_user
      .subscriptions
      .find_or_initialize_by(course_slug: course_slug) do |subscription|
        last_timezone = current_user
          .subscriptions
          .order(:updated_at)
          .last
          &.user_timezone

        subscription.user = current_user
        subscription.course_slug = course_slug
        subscription.main_language = LocalesService.current
        subscription.user_timezone = last_timezone || 'UTC'
        subscription.days_utc = Date::ABBR_DAYNAMES.dup
        subscription.hours_utc = [12]
      end
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    params.require(:subscription).permit(:active, :main_language, :user_timezone, :hour, other_languages: [], days: [])
  end
end
