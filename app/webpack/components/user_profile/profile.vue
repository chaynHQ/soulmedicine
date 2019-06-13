<template>
  <div id="user-profile">
    <div v-if="loading" class="text-center m-4">
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>

    <div v-if="!loading">
      <div v-if="!currentUser" id="profile-sign-in">
        <div class="alert alert-warning">
          Please sign in again to view and change your profile
        </div>
        <sign-in
          :api-key="apiKey"
          :project-id="projectId"
          :inline-flow="true"
        ></sign-in>
      </div>

      <div v-if="currentUser" id="profile-form">
        <div v-if="errorMessage" class="alert alert-danger">
          {{ errorMessage }}
        </div>
        <h1>Hi there, {{ currentUser.displayName }}</h1>
        <div class="form-group row">
          <label for="displayNameField" class="col-sm-3 col-form-label">
            Display Name
          </label>
          <div class="col-sm-9">
            <div class="input-group mb-3">
              <input
                id="displayNameField"
                ref="displayNameField"
                v-model="newDisplayName"
                name="newDisplayName"
                type="text"
                class="form-control"
                placeholder="Display Name"
                required
                aria-label="User's display name"
                aria-describedby="updateDisplayNameButton"
              />
              <div class="input-group-append">
                <button
                  id="updateDisplayNameButton"
                  ref="updateDisplayNameButton"
                  class="btn btn-primary"
                  type="button"
                  @click="updateName"
                >
                  Update
                </button>
              </div>
            </div>
          </div>
        </div>
        <div class="form-group row">
          <label for="emailField" class="col-sm-3 col-form-label">
            Email
          </label>
          <div class="col-sm-9">
            <div class="input-group mb-3">
              <input
                id="emailField"
                ref="emailField"
                v-model="newEmail"
                name="newEmail"
                type="email"
                class="form-control"
                placeholder="Email Address"
                required
                aria-label="User's email address"
                aria-describedby="updateEmailButton"
              />
              <div class="input-group-append">
                <button
                  id="updateEmailButton"
                  ref="updateEmailButton"
                  class="btn btn-primary"
                  type="button"
                  @click="updateEmail"
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
        <div class="card bg-light mb-3">
          <div class="card-body">
            <h5 class="card-title">Set a New Password</h5>
            <form>
              <div class="form-group mb-0">
                <div class="input-group">
                  <input
                    id="passwordField"
                    ref="passwordField"
                    v-model="newPassword"
                    name="newPassword"
                    type="password"
                    required
                    pattern=".{6,}"
                    class="form-control"
                    placeholder=""
                    aria-label="User's new password"
                    aria-describedby="button-updatePassword"
                  />
                  <div class="input-group-append">
                    <button
                      id="updatePasswordButton"
                      ref="updatePasswordButton"
                      class="btn btn-primary"
                      type="button"
                      @click="updatePassword"
                    >
                      Update
                    </button>
                  </div>
                  <span class="w-100"></span>
                  <small id="emailHelpBlock" class="form-text text-muted">
                    Must be at least 6 characters long. You will be logged out
                    and will need to sign in again
                  </small>
                </div>
              </div>
            </form>
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
  </div>
</template>

<script>
import firebase from 'firebase/app';
import Axios from 'axios';
import Turbolinks from 'turbolinks';
import SignIn from '../authentication/sign_in';

import csfrTokenMixin from '../mixins/csrfTokenMixin';
import firebaseAppMixin from '../mixins/firebaseAppMixin';
import firebaseAuthStateChangedMixin from '../mixins/firebaseAuthStateChangedMixin';

export default {
  components: {
    SignIn
  },
  mixins: [csfrTokenMixin, firebaseAppMixin, firebaseAuthStateChangedMixin],
  data() {
    return {
      loading: true,
      currentUser: null,
      newDisplayName: null,
      newEmail: null,
      newPassword: null,
      errorMessage: null
    };
  },
  computed: {
    deletionMailtoLink() {
      return encodeURI(
        `mailto:team@soulmedicine.io?subject=Request Account Deletion&body=Request Deletion for ${this.currentUser.displayName} (email address: ${this.currentUser.email})`
      );
    }
  },
  created() {},
  mounted() {},
  destroyed() {
    return firebase.auth().signOut();
  },
  methods: {
    onAuthStateChanged(user) {
      this.loading = false;

      this.currentUser = user;

      if (user) {
        this.newDisplayName = user.displayName;
        this.newEmail = user.email;
        this.newPassword = null;

        this.$nextTick(this.afterSignIn);
      }
    },
    afterSignIn() {
      const {
        passwordField,
        updatePasswordButton,
        emailField,
        updateEmailButton,
        displayNameField,
        updateDisplayNameButton
      } = this.$refs;

      this.setUpValidityHandling(passwordField, updatePasswordButton);
      this.setUpValidityHandling(emailField, updateEmailButton);
      this.setUpValidityHandling(displayNameField, updateDisplayNameButton);
    },
    setUpValidityHandling(field, button) {
      button.disabled = !field.checkValidity();
      field.addEventListener('keyup', () => {
        button.disabled = !field.checkValidity();
      });
    },
    updateName() {
      if (!this.newDisplayName) {
        this.errorMessage = 'Display name cannot be blank';
        return null;
      }

      const firebaseUpdateFn = (vm, user) =>
        user.updateProfile({ displayName: vm.newDisplayName });

      const serverUpdateFn = vm =>
        vm
          .updateProfileOnServer({ display_name: vm.newDisplayName })
          .then(() => {
            Turbolinks.clearCache();
            Turbolinks.visit('/');
          });

      return this.update(firebaseUpdateFn, serverUpdateFn);
    },
    updateEmail() {
      if (!this.newEmail) {
        this.errorMessage = 'Email cannot be blank';
        return null;
      }

      const firebaseUpdateFn = (vm, user) => user.updateEmail(vm.newEmail);

      const serverUpdateFn = vm =>
        vm
          .updateProfileOnServer({ email: vm.newEmail })
          .then(vm.afterEmailUpdate);

      return this.update(firebaseUpdateFn, serverUpdateFn);
    },
    updatePassword() {
      const firebaseUpdateFn = (vm, user) =>
        user.updatePassword(vm.newPassword);

      const serverUpdateFn = this.afterPasswordUpdate;

      return this.update(firebaseUpdateFn, serverUpdateFn);
    },
    update(firebaseUpdateFn, serverUpdateFn) {
      this.errorMessage = null;

      const user = firebase.auth().currentUser;
      const vm = this;
      vm.loading = true;
      return firebaseUpdateFn(vm, user)
        .then(() => {
          return serverUpdateFn(vm);
        })
        .catch(reason => {
          this.errorMessage = reason;
          throw new Error(reason);
        })
        .finally(() => {
          vm.loading = false;
        });
    },
    updateProfileOnServer(data) {
      return Axios.put('/profile', data, {
        headers: { 'X-CSRF-TOKEN': this.csrfToken }
      });
    },
    afterEmailUpdate() {
      const user = firebase.auth().currentUser;
      const vm = this;
      return user.sendEmailVerification().then(() => {
        return firebase
          .auth()
          .signOut()
          .then(() => {
            const message =
              'Please verify your updated email address by clicking on the link in the verification email sent to you.';
            vm.serverSignOut(message);
          });
      });
    },
    afterPasswordUpdate() {
      const vm = this;
      return firebase
        .auth()
        .signOut()
        .then(() => {
          const message = 'Please sign in using your new password.';
          vm.serverSignOut(message);
        });
    },
    serverSignOut(message) {
      Turbolinks.clearCache();
      Turbolinks.visit(`/auth/sign_out?message=${encodeURIComponent(message)}`);
    }
  }
};
</script>

<style></style>
