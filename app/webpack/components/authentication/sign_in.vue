<template>
  <div id="authentication-sign-in">
    <div v-if="loading" class="text-center m-4">
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>

    <div
      v-if="!loading && !showTermsStep && !showVerificationStep"
      ref="firebaseAuthContainer"
    >
      <template v-if="!inlineFlow">
        <h5 class="my-4 mx-auto">
          If you are signing up for the first time, you can give us any name
          like "Marshmallow Forest".
        </h5>
        <h5 class="my-4 mx-auto">
          And if you’re signing in, welcome back superstar!
        </h5>
      </template>
    </div>

    <div v-if="!loading && showTermsStep">
      <div class="mdl-card mdl-shadow--2dp firebaseui-container">
        <form @submit.prevent="handleTermsAccept">
          <div class="firebaseui-card-header">
            <h1 class="firebaseui-title">
              Notifications and Privacy Policy
            </h1>
          </div>
          <div class="firebaseui-card-content">
            <div class="firebaseui-relative-wrapper">
              <div class="mdl-card__supporting-text">
                We care about your privacy! We will securely store the
                information you have provided to us (name, email, language,
                timezone and IP address) for a minimum of 9 months. If you want
                us to remove this information, we will delete it. Your
                information might be shared with other apps such as analytics to
                see who is using Soul Medicine, this helps us improve it.
                Detailed info can be found in our
                <a :href="privacyPolicyUrl" target="_blank">Privacy Policy</a>.
              </div>
              <div class="mdl-card__supporting-text">
                We will be emailing you about important system updates and you
                can choose when else you want to hear from us.
              </div>
              <ul class="mdl-list">
                <li class="mdl-list__item">
                  Announcements about Soul Medicine
                </li>
                <li class="mdl-list__item">
                  Updates about new courses
                </li>
                <li class="mdl-list__item">
                  Updates on existing courses
                </li>
              </ul>

              <label
                class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect"
                for="acceptCheckBox"
              >
                <input
                  id="acceptCheckBox"
                  ref="acceptCheckBox"
                  type="checkbox"
                  class="mdl-checkbox__input"
                  required
                />
                <span class="mdl-checkbox__label">
                  I have read and agree to the
                  <a :href="privacyPolicyUrl" target="_blank">Privacy Policy</a>
                  and <a :href="tosUrl" target="_blank">Terms of Service</a>
                </span>
              </label>
            </div>
          </div>
          <div class="firebaseui-card-actions">
            <div class="firebaseui-form-actions">
              <button
                id="acceptButton"
                ref="acceptButton"
                type="submit"
                class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored"
                data-upgraded=",MaterialButton"
              >
                Accept and sign in
              </button>
            </div>
          </div>
        </form>
      </div>

      <p class="mt-3 font-bold" style="font-size: 1.4em; text-align: center;">
        OR
      </p>

      <div class="mdl-card mdl-shadow--2dp firebaseui-container">
        <div class="firebaseui-card-header">
          <h1 class="firebaseui-title">
            Reject and don't proceed
          </h1>
        </div>
        <div class="firebaseui-card-content">
          <div class="firebaseui-relative-wrapper">
            <div class="mdl-card__supporting-text">
              You can choose to not proceed and reject the Privacy Policy and
              Terms of Service.
              <br />
              <br />
              Clicking on the button below will sign you out, and then pop open
              a window where you can request deletion of your account.
            </div>
          </div>
        </div>
        <div class="firebaseui-card-actions">
          <div class="firebaseui-form-actions">
            <button
              class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored"
              data-upgraded=",MaterialButton"
              @click="handleTermsReject"
            >
              Reject
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="!loading && showVerificationStep" class="p-4 text-center">
      <h4>Thanks for signing up!</h4>
      <h4><b>We've sent you an email to verify your account.</b></h4>
      <h4><b>Please check your email.</b></h4>
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
    },
    continueUrl: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      tosUrl: '/pages/terms-of-service',
      privacyPolicyUrl: '/pages/privacy-policy',
      loading: false,
      showTermsStep: false,
      showVerificationStep: false,
      idToken: null
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
      tosUrl: this.tosUrl,
      privacyPolicyUrl: this.privacyPolicyUrl
    };
    this.ui.start(this.$refs.firebaseAuthContainer, this.uiConfig);
  },
  destroyed() {
    if (!this.inlineFlow) {
      return firebase.auth().signOut();
    }

    return null;
  },
  methods: {
    onUiShown() {
      this.loading = false;
    },
    setUpValidityHandling() {
      const { acceptCheckBox, acceptButton } = this.$refs;

      acceptButton.disabled = !acceptCheckBox.checked;
      acceptCheckBox.addEventListener('click', () => {
        acceptButton.disabled = !acceptCheckBox.checked;
      });
    },
    onAuthStateChanged(user) {
      const vm = this;
      if (user) {
        vm.loading = true;
        return user
          .getIdToken(true)
          .then(idToken => {
            vm.idToken = idToken;
            vm.serverSignIn(null);
          })
          .finally(() => {
            vm.loading = false;
          });
      }
      return true;
    },
    serverSignIn(termsAccepted) {
      return Axios.post(
        '/auth/callback',
        {
          firebase_token: this.idToken,
          inline_flow: this.inlineFlow,
          terms_accepted: termsAccepted
        },
        { headers: { 'X-CSRF-TOKEN': this.csrfToken } }
      ).then(result => {
        return this.afterServerSignIn(result.data);
      });
    },
    afterServerSignIn(data) {
      // If the user has not accepted terms yet then show the terms acceptance
      // flow before carrying on.
      //
      // If the email is not verified, then the server will not have signed in,
      // and we should sign out of the Firebase Auth session and display verification message.
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

      if (data.user.terms_accepted === false) {
        this.showVerificationStep = false;
        this.showTermsStep = true;
        this.$nextTick(this.setUpValidityHandling);
        return null;
      }

      if (data.user.email_verified === false) {
        this.showTermsStep = false;
        this.showVerificationStep = true;
        const user = firebase.auth().currentUser;
        const actionCodeSettings =
          data.last_course_id != null
            ? {
                url: `${vm.continueUrl}/?last_course_id=${data.last_course_id}`
              }
            : {
                url: vm.continueUrl
              };
        return user.sendEmailVerification(actionCodeSettings).then(() => {
          return vm.clearFirebaseSession();
        });
      }

      if (!vm.inlineFlow) {
        return vm.clearFirebaseSession(data.forwarding_url).then(() => {
          vm.redirect(data.forwarding_url);
        });
      }
      return null;
    },
    clearFirebaseSession() {
      return firebase.auth().signOut();
    },
    redirect(forwardingUrl) {
      Turbolinks.clearCache();
      Turbolinks.visit(forwardingUrl || '/');
    },
    handleTermsAccept() {
      const vm = this;
      vm.loading = true;

      return this.serverSignIn(true).finally(() => {
        vm.loading = false;
      });
    },
    handleTermsReject() {
      const user = firebase.auth().currentUser;
      return firebase
        .auth()
        .signOut()
        .then(() => {
          Turbolinks.clearCache();
          Turbolinks.visit('/auth/sign_out');
          window.open(
            `mailto:team@soulmedicine.io?subject=Request Account Deletion&body=Request Deletion for ${user.displayName} (email address: ${user.email})`,
            '_self'
          );
        });
    }
  }
};
</script>

<style scoped></style>
