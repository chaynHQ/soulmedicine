<template>
  <div id="authentication-sign-in">
    <div v-if="loading" class="text-center m-4">
      <div  class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
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
    this.ui = firebaseui.auth.AuthUI.getInstance();
    if (!this.ui) {
      this.ui = new firebaseui.auth.AuthUI(firebase.auth());
    }
    this.csrf_token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');
  },
  mounted() {
    const $self = this;
    this.uiConfig = {
      signInOptions: [
        {
          provider: firebase.auth.EmailAuthProvider.PROVIDER_ID,
          requireDisplayName: true
        }
      ],
      credentialHelper: firebaseui.auth.CredentialHelper.NONE,
      callbacks: {
        uiShown() {
          $self.onUiShown();
        },
        signInSuccessWithAuthResult(authResult, redirectUrl) {
          $self.signInSuccessWithAuthResult(authResult, redirectUrl);
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
    },
    signInSuccessWithAuthResult(authResult, redirectUrl) {
      firebase
        .auth()
        .currentUser
        .getIdToken(true)
        .then(this.processIdToken)
        .catch(error => {
          console.error(error);
        });

      return false;
    },
    processIdToken(idToken) {
      return Axios.post(
        '/auth/callback',
        { firebase_token: idToken },
        { headers: { 'X-CSRF-TOKEN': this.csrf_token } }
      )
        .then(response => {
          const data = response.data;

          const onComplete = function() {
            Turbolinks.clearCache();
            Turbolinks.visit(data.forwarding_url || '/');
          }

          if (data.user.email_verified === false) {
            const user = firebase.auth().currentUser;
            return user
              .sendEmailVerification()
              .then(onComplete);
          }

          onComplete();
        });
    }
  }
};
</script>

<style scoped>
</style>
