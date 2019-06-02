require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  describe 'GET #show' do
    before do
      @controller.class.send :before_action, :require_authentication

      expect(@controller).to receive(:current_user?).and_call_original
    end
    context 'when a current_user is detected' do
      let(:user) { instance_double(User) }

      before do
        expect(@controller).to receive(:current_user)
          .and_return(user)
      end

      it 'renders the page as expected' do
        get :show
        expect(response).to have_http_status(:success)
      end
    end
    context 'when no current_user is detected' do
      before do
        expect(@controller).to receive(:current_user)
          .and_return(nil)
      end

      it 'redirects to the sign in page and sets a forwarding_url' do
        get :show
        expect(response).to redirect_to auth_sign_in_path
        expect(session[:forwarding_url]).not_to be_nil
      end
    end
  end
end
