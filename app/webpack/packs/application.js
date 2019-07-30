/* eslint-disable no-unused-vars */
import '../stylesheets/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import 'bootstrap/dist/js/bootstrap';
import 'bootstrap-select';
import 'data-confirm-modal';

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import SignIn from '../components/authentication/sign_in.vue';
import Profile from '../components/user_profile/profile.vue';
import CookieLaw from '../components/cookie_law/cookie_law.vue';

Rails.start();
Turbolinks.start();

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const components = [
    {
      element_id: 'sign_in',
      components: { SignIn },
      data: {}
    },
    {
      element_id: 'profile',
      components: { Profile },
      data: {}
    },
    {
      element_id: 'cookie-law',
      components: { CookieLaw },
      data: {}
    }
  ];

  components.forEach(e => {
    const element = document.getElementById(e.element_id);
    if (element != null) {
      const app = new Vue({
        el: element,
        components: e.components,
        data: e.data
      });
    }
  });
});

// Make bootstrap-select work with Turbolinks
document.addEventListener('turbolinks:load', () => {
  $(window).trigger('load.bs.select.data-api'); // eslint-disable-line no-undef
});
