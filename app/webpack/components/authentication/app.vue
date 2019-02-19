<template>
  <div id="authentication-app">
    <sign-in></sign-in>
  </div>
</template>

<script>
import firebase from 'firebase/app';
import SignIn from './sign_in';

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
    return {};
  },
  created() {
    if (!firebase.apps.length) {
      this.firebaseConfig = {
        apiKey: this.apiKey,
        authDomain: `${this.projectId}.firebaseapp.com`,
        projectId: this.projectId
      };
      firebase.initializeApp(this.firebaseConfig);
    }
  }
};
</script>
