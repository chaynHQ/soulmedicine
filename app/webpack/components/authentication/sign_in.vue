<template>
  <div id="authentication-sign-in">
    <div v-if="loading" class="text-center m-4">
      <div class="spinner-border" role="status">
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

import csfrTokenMixin from '../mixins/csrfTokenMixin';
import firebaseAppMixin from '../mixins/firebaseAppMixin';
import firebaseAuthStateChangedMixin from '../mixins/firebaseAuthStateChangedMixin';

export default {
  mixins: [csfrTokenMixin, firebaseAppMixin, firebaseAuthStateChangedMixin],
  props: {
    inlineFlow: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data() {
    return {
      loading: true
    };
  },
  created() {
    this.ui = firebaseui.auth.AuthUI.getInstance();
    if (!this.ui) {
      this.ui = new firebaseui.auth.AuthUI(firebase.auth());
    }
  },
  mounted() {
    const vm = this;
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
          vm.onUiShown();
        },
        signInSuccessWithAuthResult() {
          return false;
        }
      },
      tosUrl: '/pages/terms-of-service',
      privacyPolicyUrl: '/pages/privacy-policy'
    };
    this.ui.start(this.$refs.firebaseAuthContainer, this.uiConfig);
  },
  methods: {
    onUiShown() {
      this.loading = false;
    },
    onAuthStateChanged(user) {
      const vm = this;
      if (user) {
        vm.loading = true;
        return user
          .getIdToken(true)
          .then(this.serverSignIn)
          .finally(() => {
            vm.loading = false;
          });
      }
      return true;
    },
    serverSignIn(idToken) {
      return Axios.post(
        '/auth/callback',
        {
          firebase_token: idToken,
          inline_flow: this.inlineFlow
        },
        { headers: { 'X-CSRF-TOKEN': this.csrfToken } }
      ).then(result => {
        return this.afterServerSignIn(result.data);
      });
    },
    afterServerSignIn(data) {
      // If the email is not verified, then the server will not have signed in,
      // and we should sign out of the Firebase Auth session and redirect away.
      //
      // Otherwise…
      //
      // If we're in an inline flow:
      // - Keep the Firebase Auth session alive
      // - Don't redirect at the end
      //
      // If we're *not* in an inline flow:
      // - Sign out of the Firebase Auth session
      // - Redirect to the forwarding_url (or homepage)

      const vm = this;

      if (data.user.email_verified === false) {
        const user = firebase.auth().currentUser;
        return user.sendEmailVerification().then(() => {
          return vm.clearFirebaseSessionAndRedirect(data.forwarding_url);
        });
      }

      if (!this.inlineFlow) {
        return vm.clearFirebaseSessionAndRedirect(data.forwarding_url);
      }

      return null;
    },
    clearFirebaseSessionAndRedirect(forwardingUrl) {
      return firebase
        .auth()
        .signOut()
        .then(() => {
          Turbolinks.clearCache();
          Turbolinks.visit(forwardingUrl || '/');
        });
    }
  }
};
</script>

<style scoped></style>
