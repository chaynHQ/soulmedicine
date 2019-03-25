class SubscriptionsController < ApplicationController
  before_action :require_authentication

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
    params[:days_utc].reject!(&:blank?) if params.key?(:days_utc)
    params[:hours_utc].reject!(&:blank?) if params.key?(:hours_utc)

    if @subscription.update(params)
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
    @subscription.update! active: false

    redirect_to subscriptions_url, notice: 'Subscription was successfully paused.'
  end

  # PATCH /pathways/:course_id/subscription/unpause
  def unpause
    @subscription.update! active: true

    redirect_to subscriptions_url, notice: 'Subscription was successfully activated.'
  end

  private

  def find_or_initialize_subscription
    course_slug = params[:course_id]

    @subscription = current_user
      .subscriptions
      .find_or_initialize_by(course_slug: course_slug) do |subscription|
        subscription.user = current_user
        subscription.course_slug = course_slug
        subscription.main_language = LocalesService.current
        subscription.days_utc = Subscription::DAYS.dup
      end
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    params.require(:subscription).permit(:active, :main_language, other_languages: [], days_utc: [], hours_utc: [])
  end
end
