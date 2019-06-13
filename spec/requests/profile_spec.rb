require 'rails_helper'

RSpec.describe 'Profile', type: :request do
  describe 'show - GET /profile' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        get profile_path
      end
    end

    it_behaves_like 'authenticated' do
      it 'loads the profile page' do
        get profile_path
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'update - PUT /profile' do
    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        put profile_path
      end
    end

    it_behaves_like 'authenticated' do
      it 'updates the current user' do
        put profile_path, params: { display_name: 'brand new name' }
        expect(response).to be_successful
        expect(current_user.reload.display_name).to eq 'brand new name'
      end
    end
  end
end
