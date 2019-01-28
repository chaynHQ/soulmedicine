<template>
  <div id="authentication-app">
    <log-in v-if="!isAuthenticated"></log-in>
  </div>
</template>

<script>
import firebase from 'firebase/app';
import LogIn from './log_in';
export default {
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
  created() {
    this.firebaseConfig = {
      apiKey: this.apiKey,
      authDomain: `${this.projectId}.firebaseapp.com`,
      projectId: this.projectId
    };
    firebase.initializeApp(this.firebaseConfig);
  },
  data: function() {
    return {
      isAuthenticated: false
    };
  },
  mounted() {
    this.checkAuth();
  },
  methods: {
    checkAuth() {
      let $self = this;
      firebase.auth().onAuthStateChanged(user => {
        if (user) {
          $self.isAuthenticated = true;
        } else {
          $self.isAuthenticated = false;
        }
      });
    }
  },
  components: {
    LogIn
  }
};
</script>

<style lang="sass" scoped>

</style>

