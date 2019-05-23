require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'index - GET /subscriptions' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        get subscriptions_path
      end
    end

    it_behaves_like 'authenticated' do
      it 'loads the current user\'s subscriptions only' do
        expect(current_user).to receive(:subscriptions)
          .and_return([])
        get subscriptions_path
        expect(response).to be_successful
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'show - GET /pathways/:course_id/subscription' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        get course_subscription_path('en', 'foo')
      end
    end
  end

  describe 'update - PUT /pathways/:course_id/subscription' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        expect do
          put course_subscription_path('en', 'foo')
        end.not_to change(Subscription, :count)
      end
    end
  end

  describe 'destroy - DELETE /pathways/:course_id/subscription' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        expect do
          delete course_subscription_path('en', 'foo')
        end.not_to change(Subscription, :count)
      end
    end
  end

  describe 'pause - PATCH /pathways/:course_id/subscription/pause' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        patch pause_course_subscription_path('en', 'foo')
      end
    end
  end

  describe 'unpause - PATCH /pathways/:course_id/subscription/unpause' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        patch unpause_course_subscription_path('en', 'foo')
      end
    end
  end
end
