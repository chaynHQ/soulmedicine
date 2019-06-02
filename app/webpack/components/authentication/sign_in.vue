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

export default {
  mixins: [csfrTokenMixin, firebaseAppMixin],
  props: {
    signOutFirebaseAfterServerSignIn: {
      type: Boolean,
      required: false,
      default: true
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

    this.onAuthStateChangedSubscription = firebase
      .auth()
      .onAuthStateChanged(user => {
        if (user) {
          this.loading = true;
          return user
            .getIdToken(true)
            .then(this.serverSignIn)
            .finally(() => {
              this.loading = false;
            });
        }
        return true;
      });
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
        signInSuccessWithAuthResult() {
          return false;
        }
      },
      tosUrl: '/terms-of-service',
      privacyPolicyUrl: '/privacy-policy'
    };
    this.ui.start(this.$refs.firebaseAuthContainer, this.uiConfig);
  },
  destroyed() {
    if (this.onAuthStateChangedSubscription) {
      this.onAuthStateChangedSubscription();
    }
  },
  methods: {
    onUiShown() {
      this.loading = false;
    },
    serverSignIn(idToken) {
      return Axios.post(
        '/auth/callback',
        { firebase_token: idToken },
        { headers: { 'X-CSRF-TOKEN': this.csrf_token } }
      ).then(result => {
        const { data } = result;

        if (data.user.email_verified === false) {
          const user = firebase.auth().currentUser;
          return user
            .sendEmailVerification()
            .then(() => this.afterServerSignIn(data.forwarding_url));
        }

        return this.afterServerSignIn(data.forwarding_url);
      });
    },
    afterServerSignIn(forwardingUrl) {
      if (this.signOutFirebaseAfterServerSignIn) {
        return this.firebaseSignOut(forwardingUrl);
      }
      Turbolinks.clearCache();
      return this.$emit('ServerSignedIn', { forwarding_url: forwardingUrl });
    },
    firebaseSignOut(forwardingUrl) {
      // Once we're done with the token, and signed in by the server, we
      // don't need the Firebase Auth session anymore, so sign that out.
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
