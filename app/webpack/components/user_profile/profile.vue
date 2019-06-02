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
        Please sign in again to modify your profile
      </div>
      <sign-in
        :api-key="apiKey"
        :project-id="projectId"
        :sign-out-after-server-sign-in="false"
        @ServerSignedIn="onServerSignedIn"
      ></sign-in>
    </div>
    <div v-if="currentUser" id="user-profile-form">
      <h1>Hi there, {{ currentUser.displayName }}</h1>
      <div class="form-group row">
        <label for="inputDisplayName" class="col-sm-3 col-form-label">
          Display Name
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
                @click="onUpdateName"
              >
                Update
              </button>
            </div>
            <span class="w-100"></span>
            <small id="nameHelpBlock" class="form-text text-muted"></small>
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label for="inputEmail" class="col-sm-3 col-form-label">
          Email
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
                @click="onUpdateEmail"
              >
                Update
              </button>
            </div>
            <span class="w-100"></span>
            <small id="emailHelpBlock" class="form-text text-muted">
              You will be logged out and will need to re-verify your new email
              address
            </small>
          </div>
        </div>
      </div>
      <div class="card bg-light">
        <div class="card-body">
          <h5 class="card-title">Delete Your Account?</h5>
          <h6 class="card-subtitle mb-2 text-muted">
            We're sorry to see you go
          </h6>
          <p class="card-text">
            Account deletion is final, with restoration not possible. In order
            to comply with local and international regulations, it may take up
            to two weeks for your account to be entirely removed from our
            systems.
          </p>
          <a :href="deletionMailtoLink" class="card-link">
            Request account deletion
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase, { initializeApp } from 'firebase/app';
import Axios from 'axios';
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
      csrf_token: null,
      currentUser: null,
      showSignIn: false,
      displayName: null,
      userEmail: null
    };
  },
  computed: {
    deletionMailtoLink() {
      return this.currentUser
        ? encodeURI(
            `mailto:team@soulmedicine.io?subject=Request Account Deletion&body=Request Deletion for ${
              this.currentUser.displayName
            } (email address: ${this.currentUser.email})`
          )
        : false;
    }
  },
  created() {
    if (!firebase.apps.length) {
      this.initializeFirebaseApp();
    }
    this.csrf_token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');

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
  destroyed() {
    if (this.onAuthStateChangedSubscription) {
      this.onAuthStateChangedSubscription();
    }
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
    firebaseSignOut(serverSignOut) {
      const visitLocation = serverSignOut ? '/auth/sign_out' : window.location;
      return firebase
        .auth()
        .signOut()
        .then(() => {
          Turbolinks.clearCache();
          Turbolinks.visit(visitLocation);
        });
    },
    sendUpdate(data) {
      const vm = this;
      return Axios.put('/profile', data, {
        headers: { 'X-CSRF-TOKEN': this.csrf_token }
      })
        .then(response => {
          vm.onUpdateSuccess(response);
        })
        .catch(error => {
          throw new Error(error);
        })
        .then(() => {
          vm.loading = false;
        });
    },
    onUpdateName() {
      const user = firebase.auth().currentUser;
      const vm = this;
      this.loading = true;
      return user
        .updateProfile({
          displayName: this.displayName
        })
        .then(() => {
          // Update the Rails App
          vm.sendUpdate({
            display_name: this.displayName
          });
        })
        .catch(reason => {
          throw new Error(reason);
        });
    },
    onUpdateEmail() {
      const user = firebase.auth().currentUser;
      const vm = this;
      this.loading = true;
      return user
        .updateEmail(this.userEmail)
        .then(() => {
          // Update the Rails App
          vm.sendUpdate({
            email: vm.userEmail,
            email_verified: false
          });
        })
        .catch(reason => {
          throw new Error(reason);
        });
    },
    onUpdateSuccess(serverResponse) {
      const signOut = serverResponse.email_verified === false ? true : null;
      this.firebaseSignOut(signOut);
    }
  }
};
</script>

<style></style>
