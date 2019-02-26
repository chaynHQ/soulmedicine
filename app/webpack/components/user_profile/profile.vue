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
      <h1>Hi there, {{ currentUser.displayName }}</h1>
      <form>
        <div class="form-group row">
          <label for="inputDisplayName" class="col-sm-3 col-form-label"
            >Display Name</label
          >
          <div class="col-sm-9">
            <input
              id="inputDisplayName"
              v-model="displayName"
              type="text"
              class="form-control"
              placeholder="Display Name"
            />
          </div>
        </div>
        <div class="form-group row">
          <label for="inputEmail" class="col-sm-3 col-form-label">Email</label>
          <div class="col-sm-9">
            <input
              id="inputEmail"
              v-model="userEmail"
              type="email"
              class="form-control"
              placeholder="Email Address"
            />
          </div>
        </div>
      </form>
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
    },
    authenticateMessage: {
      type: String,
      required: false,
      default: 'Please authenticate to modify profile'
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
