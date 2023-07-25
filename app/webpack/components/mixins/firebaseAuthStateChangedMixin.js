import firebase from 'firebase/app';

const firebaseAuthStateChangedMixin = {
  created() {
    this.onAuthStateChangedSubscription = firebase
      .auth()
      .onAuthStateChanged(this.onAuthStateChanged);
  },
  destroyed() {
    if (this.onAuthStateChangedSubscription) {
      this.onAuthStateChangedSubscription();
    }
  },
};

export default firebaseAuthStateChangedMixin;
