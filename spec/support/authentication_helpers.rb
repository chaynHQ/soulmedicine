module AuthenticationHelpers
  RSpec.shared_examples 'unauthenticated redirects to sign in' do
    it 'redirects to the sign in page' do
      expect(response).to redirect_to auth_sign_in_path
    end
  end

  RSpec.shared_examples 'authenticated' do
    let(:current_user) { create :user }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user)
        .and_return(current_user)
    end
  end
end
