<template>
  <div id="authentication-sign-in">
    <div class="loader" v-if="loading">loading...</div>
    <div ref="firebaseAuthContainer"></div>
  </div>
</template>

<script>
import firebase from 'firebase/app';
import 'firebase/auth';
import firebaseui from 'firebaseui';
import 'firebaseui/dist/firebaseui.css';
import Axios from 'axios';
import Turbolinks from 'turbolinks';
export default {
  created() {
    this.ui = new firebaseui.auth.AuthUI(firebase.auth());
    this.csrf_token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');
  },
  mounted() {
    let $self = this;
    this.uiConfig = {
      signInOptions: [
        {
          provider: firebase.auth.EmailAuthProvider.PROVIDER_ID,
          requireDisplayName: true
        }
      ],
      credentialHelper: firebaseui.auth.CredentialHelper.NONE,
      callbacks: {
        signInSuccessWithAuthResult(authResult, redirectUrl) {
          firebase
            .auth()
            .currentUser.getIdToken(true)
            .then(idtoken => {
              Axios.post(
                '/auth/callback',
                { firebase_token: idtoken },
                { headers: { 'X-CSRF-TOKEN': $self.csrf_token } }
              )
                .then(response => {
                  if (response.data.user.email_verified === false) {
                    const user = firebase.auth().currentUser;
                    user
                      .sendEmailVerification()
                      .then(() => {
                        console.log('Verification Email Sent');
                      })
                      .catch(error => {
                        console.error(error);
                      });
                  }
                  if (response.data.forwarding_url) {
                    Turbolinks.visit(response.data.forwarding_url);
                  }
                })
                .catch(error => {
                  console.error(error);
                });
            })
            .catch(error => {
              console.error(error);
            });
        },
        uiShown() {
          $self.onUiShown();
        }
      },
      tosUrl: '/terms-of-service',
      privacyPolicyUrl: '/privacy-policy'
    };
    this.ui.start(this.$refs.firebaseAuthContainer, this.uiConfig);
  },
  data: function() {
    return {
      loading: true,
      csrf_token: null
    };
  },
  methods: {
    onUiShown() {
      this.loading = false;
    }
  }
};
</script>

<style scoped>
</style>

