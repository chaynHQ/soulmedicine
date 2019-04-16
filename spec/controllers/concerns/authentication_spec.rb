require 'rails_helper'

RSpec.describe 'Authentication Concern', type: :controller do
  include_context 'time helpers'

  controller(ActionController::Base) do
    include Authentication

    def index
      head :no_content
    end
  end

  describe '#require_authentication used in before_action' do
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
        get :index
        expect(response).to be_successful
        expect(response).to have_http_status(204)
      end
    end

    context 'when no current_user is detected' do
      before do
        expect(@controller).to receive(:current_user)
          .and_return(nil)
      end

      it 'redirects to the sign in page and sets a forwarding_url' do
        get :index
        expect(response).to redirect_to auth_sign_in_path
        expect(session[:forwarding_url]).not_to be_nil
      end
    end
  end

  describe '#current_user' do
    context 'with a valid user session' do
      let(:user) { create :user }

      before do
        @controller.session[:user] = user.id
      end

      it 'loads up the current_user as expected' do
        expect(@controller.current_user).to eq user
      end

      it 'updates the user\'s last_seen_at timestamp' do
        new_time = now + 5.minutes
        move_time_to new_time
        expect(@controller.current_user.last_seen_at.to_i).to eq new_time.to_i
      end

      it 'memoizes the method' do
        expect(User).to receive(:find)
          .once
          .and_call_original

        # Check that it's the exact same instance
        expect(@controller.current_user).to be @controller.current_user
      end
    end

    context 'with no valid user session' do
      it 'has no current_user' do
        expect(@controller.current_user).to be_nil
      end
    end
  end

  describe 'with_auth_session_management' do
    before do
      @controller.class.send :with_auth_session_management
    end

    describe '#sign_in_with_token' do
      let(:token) { double }

      let :token_payload do
        {
          'user_id' => 'firebase-243r325435',
          'name' => 'Jane Bloggs',
          'email' => 'foo@example.com',
          'email_verified' => false
        }
      end

      let :expected_result_user do
        {
          'firebase_id' => token_payload['user_id'],
          'display_name' => token_payload['name'],
          'email' => token_payload['email'],
          'email_verified' => token_payload['email_verified']
        }
      end

      let(:firebase_auth_service) { instance_double(FirebaseAuthService) }

      before do
        allow(@controller).to receive(:firebase_auth_service)
          .and_return(firebase_auth_service)

        allow(firebase_auth_service).to receive(:verify_and_get_token_payload)
          .with(token)
          .and_return(token_payload)
      end

      shared_examples_for 'sign in with token' do
        context 'when policy is not accepted' do
          it 'creates session when and accepts privacy policy' do
            result = @controller.sign_in_with_token(token)
            expect(result[:user]['id']).not_to be_nil
            expect(result[:user]).to include(expected_result_user)
            expect(@controller.session[:user]).not_to be_nil
            result = @controller.accept_user_policy
            expect(result).not_to be_nil
            expect(@controller.session[:user]).not_to be_nil
          end
        end
        context 'when email is not verified' do
          it 'doesn\'t sign the user in and sets an alert flash' do
            @controller.sign_in_with_token(token)
            @controller.accept_user_policy
            result = @controller.sign_in_with_token(token)
            expect(result[:user]['id']).not_to be_nil
            expect(result[:user]).to include(expected_result_user)
            expect(@controller.session[:user]).to be_nil
            expect(@controller.flash[:alert]).to be_present
          end
        end

        context 'when email is verified' do
          before do
            token_payload['email_verified'] = true
          end

          it 'signs the user in by setting the user session' do
            result = @controller.sign_in_with_token(token)
            expect(result[:user]['id']).not_to be_nil
            expect(result[:user]).to include(expected_result_user)
            expect(@controller.session[:user]).to be result[:user]['id']
            expect(@controller.flash[:alert]).to be_nil
          end
        end
      end

      before do
        # Create a pool of existing users "on the side"
        create_list :user, 2
      end

      context 'when authed user does not exist yet in the db' do
        include_examples 'sign in with token'

        it 'creates a new user' do
          expect do
            @controller.sign_in_with_token(token)
          end.to change(User, :count).by(1)
        end
      end

      context 'when authed user exists in the db' do
        before do
          create :user, firebase_id: token_payload['user_id']
        end

        include_examples 'sign in with token'

        it 'does not create a new user' do
          expect do
            @controller.sign_in_with_token(token)
          end.not_to change(User, :count)
        end
      end
    end

    describe '#sign_out_current_user' do
      before do
        @controller.session[:user] = '1234'
      end

      it 'clears the user session' do
        expect(@controller.session[:user]).not_to be_nil
        @controller.sign_out_current_user
        expect(@controller.session[:user]).to be_nil
      end
    end
  end
end
