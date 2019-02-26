<template>
  <div id="user-profile">
    <div v-if="loading" class="text-center m-4">
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
    <div v-if="showSignIn" id="user-authenticate">
      <div v-if="showSignIn" class="alert alert-dismissible alert-warning">
        <button
          type="button"
          class="close"
          data-dismiss="alert"
          aria-hidden="true"
        >
          &times;
        </button>
        {{ authenticateMessage }}
      </div>
      <sign-in
        :api-key="apiKey"
        :project-id="projectId"
        :sign-out-after-sever-sign-in="false"
        @ServerSignedIn="onServerSignedIn"
      ></sign-in>
    </div>
    <div v-if="currentUser" id="user-profile-form">
      <h1>{{ pageHeader }}</h1>
      <div class="form-group row">
        <label for="inputDisplayName" class="col-sm-3 col-form-label">
          {{ displayNameI18n }}
        </label>
        <div class="col-sm-9">
          <div class="input-group mb-3">
            <input
              id="inputDisplayName"
              v-model="displayName"
              type="text"
              class="form-control"
              placeholder="Display Name"
              aria-label="Recipient's display name"
              aria-describedby="button-updateDisplay"
            />
            <div class="input-group-append">
              <button
                id="button-updateDisplay"
                class="btn btn-secondary"
                type="button"
              >
                {{ updateI18n }}
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label for="inputEmail" class="col-sm-3 col-form-label">
          {{ emailI18n }}
        </label>
        <div class="col-sm-9">
          <div class="input-group mb-3">
            <input
              id="inputEmail"
              v-model="userEmail"
              type="email"
              class="form-control"
              placeholder="Email Address"
              aria-label="Recipient's email address"
              aria-describedby="button-updateEmail"
            />
            <div class="input-group-append">
              <button
                id="button-updateEmail"
                class="btn btn-secondary"
                type="button"
              >
                {{ updateI18n }}
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="card bg-light">
        <h5 class="card-title">Delete Your Account?</h5>
        <h6 class="card-subtitle mb-2 text-muted">We're sorry to see you go</h6>
        <div class="card-body">
          If you so desire, you can also delete your profile from Soul Medicine
          entirely
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase, { initializeApp } from 'firebase/app';
import Turbolinks from 'turbolinks';
import SignIn from '../authentication/sign_in';

export default {
  components: {
    SignIn
  },
  props: {
    apiKey: {
      type: String,
      required: true
    },
    projectId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      loading: true,
      currentUser: null,
      showSignIn: false,
      displayName: null,
      userEmail: null
    };
  },
  computed: {
    authenticateMessage() {
      return window.I18n.t('profile.authenticate-again', {
        defaultValue: 'Please authenticate again'
      });
    },
    pageHeader() {
      return this.currentUser
        ? window.I18n.t('profile.page-header', {
            name: this.currentUser.displayName
          })
        : false;
    },
    displayNameI18n() {
      return this.currentUser
        ? window.I18n.t('profile.form.display-name', {
            defaultValue: 'Display Name'
          })
        : false;
    },
    emailI18n() {
      return this.currentUser
        ? window.I18n.t('profile.form.email', {
            defaultValue: 'Email'
          })
        : false;
    },
    updateI18n() {
      return this.currentUser
        ? window.I18n.t('profile.form.update', {
            defaultValue: 'Update'
          })
        : false;
    }
  },
  created() {
    if (!firebase.apps.length) {
      this.initializeFirebaseApp();
    }
    this.onAuthStateChangedSubscription = firebase
      .auth()
      .onAuthStateChanged(user => {
        if (user) {
          this.loading = false;
          this.currentUser = user;
          this.displayName = user.displayName;
          this.userEmail = user.email;
          return user;
        }
        this.showSignIn = true;
        this.loading = false;

        return true;
      });
  },
  methods: {
    initializeFirebaseApp() {
      this.firebaseConfig = {
        apiKey: this.apiKey,
        authDomain: `${this.projectId}.firebaseapp.com`,
        projectId: this.projectId
      };
      initializeApp(this.firebaseConfig);
    },
    onServerSignedIn() {
      Turbolinks.visit(window.location);
    },
    firebaseSignOut(forwardingUrl) {
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

<style></style>
