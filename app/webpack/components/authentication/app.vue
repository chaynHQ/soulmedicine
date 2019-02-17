<template>
  <div id="authentication-app">
    <sign-in></sign-in>
  </div>
</template>

<script>
import firebase from 'firebase/app';
import SignIn from './sign_in';

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
    if (!firebase.apps.length) {
      this.firebaseConfig = {
        apiKey: this.apiKey,
        authDomain: `${this.projectId}.firebaseapp.com`,
        projectId: this.projectId
      };
      firebase.initializeApp(this.firebaseConfig);
    }
  },
  data: function() {
    return {};
  },
  components: {
    SignIn
  }
};
</script>
