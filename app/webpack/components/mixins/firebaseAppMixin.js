import firebase, { initializeApp } from 'firebase/app';

const firebaseAppMixin = {
  props: {
    apiKey: {
      type: String,
      required: true,
    },
    projectId: {
      type: String,
      required: true,
    },
  },
  created() {
    if (!firebase.apps.length) {
      this.firebaseConfig = {
        apiKey: this.apiKey,
        authDomain: `${this.projectId}.firebaseapp.com`,
        projectId: this.projectId,
      };
      initializeApp(this.firebaseConfig);
    }
  },
};

export default firebaseAppMixin;
