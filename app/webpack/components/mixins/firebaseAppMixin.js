import firebase from 'firebase/compat/app';

const firebaseAppMixin = {
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
  }
};

export default firebaseAppMixin;
