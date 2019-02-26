/* eslint-disable no-unused-vars */
import '../stylesheets/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import 'bootstrap/dist/js/bootstrap';
import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import SignIn from '../components/authentication/sign_in.vue';
import Profile from '../components/user_profile/profile.vue';

Rails.start();
Turbolinks.start();

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const signInEl = document.getElementById('sign_in');
  const profileEl = document.getElementById('profile');
  if (signInEl != null) {
    const app = new Vue({
      el: signInEl,
      components: {
        SignIn
      },
      data: {}
    });
  }
  if (profileEl != null) {
    const app = new Vue({
      el: profileEl,
      components: {
        Profile
      },
      data: {}
    });
  }
});
