<template>
  <div id="authentication-sign-in">
    <div v-if="loading" class="text-center m-4">
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
    <div ref="firebaseAuthContainer"></div>
    <div
      v-if="userAcceptedPrivacyPolicy === false"
      class="mdl-card mdl-shadow--2dp firebaseui-container"
    >
      <form @submit.prevent="handlePrivacyPolicySubmit">
        <div class="firebaseui-card-header">
          <h1 class="firebaseui-title">
            Notifications and Privacy Policy
          </h1>
        </div>
        <div class="firebaseui-card-content">
          <div class="firebaseui-relative-wrapper">
            <div class="mdl-card__supporting-text">
              We will be emailing you about important system updates and you can
              choose when else you want to hear from us!
            </div>
            <ul class="mdl-list">
              <li class="mdl-list__item">
                Announcements about Soul Medicine
              </li>
              <li class="mdl-list__item">
                Updates about new courses
              </li>
              <li class="mdl-list__item">
                Updates on existing courses?
              </li>
            </ul>
            <label
              class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect"
              for="accept-tos"
            >
              <input
                id="accept-tos"
                v-model="policy_accepted"
                type="checkbox"
                class="mdl-checkbox__input"
                required
              />
              <span class="mdl-checkbox__label">
                I have read and agree to the
                <a href="/terms-of-service" target="_blank">Terms of Service</a>
              </span>
            </label>
          </div>
        </div>
        <div class="firebaseui-card-actions">
          <div class="firebaseui-form-actions">
            <button
              class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored"
              data-upgraded=",MaterialButton"
            >
              Finish Sign In
            </button>
          </div>
        </div>
        <div class="firebaseui-card-footer"></div>
      </form>
    </div>
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
  data() {
    return {
      loading: true,
      csrf_token: null,
      userAcceptedPrivacyPolicy: null,
      policy_accepted: false
    };
  },
  created() {
    this.ui = firebaseui.auth.AuthUI.getInstance();
    if (!this.ui) {
      this.ui = new firebaseui.auth.AuthUI(firebase.auth());
    }

    this.csrf_token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');

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
    showPrivacyPolicyCard(token) {
      this.loginToken = token;
      this.userAcceptedPrivacyPolicy = false;
    },
    serverSignIn(idToken) {
      const token = idToken;
      return Axios.post(
        '/auth/callback',
        { firebase_token: token },
        { headers: { 'X-CSRF-TOKEN': this.csrf_token } }
      ).then(result => {
        const { data } = result;

        if (data.user.policy_accepted === false) {
          return this.showPrivacyPolicyCard(token);
        }

        if (data.user.email_verified === false) {
          const user = firebase.auth().currentUser;
          return user
            .sendEmailVerification()
            .then(() => this.afterServerSignIn(data.forwarding_url));
        }

        return this.afterServerSignIn(data.forwarding_url);
      });
    },
    handlePrivacyPolicySubmit() {
      return Axios.post(
        '/auth/accept_policy',
        { policy_accepted: this.policy_accepted },
        { headers: { 'X-CSRF-TOKEN': this.csrf_token } }
      ).then(() => {
        this.serverSignIn(this.loginToken);
      });
    },
    afterServerSignIn(forwardingUrl) {
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
