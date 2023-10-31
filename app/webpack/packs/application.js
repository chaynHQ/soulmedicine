import '../stylesheets/application.scss';

import Rails from '@rails/ujs';
import 'bootstrap-select';
import 'bootstrap/dist/js/bootstrap';
import 'data-confirm-modal';
import Turbolinks from 'turbolinks';

import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';

import SignIn from '../components/authentication/sign_in.vue';
import CookieLaw from '../components/cookie_law/cookie_law.vue';
import LeaveSite from '../components/leave_site/leave_site.vue';
import Profile from '../components/user_profile/profile.vue';

Rails.start();
Turbolinks.start();

Vue.use(TurbolinksAdapter);

import '../hotjar.js.erb'; // eslint-disable-line import/first
import '../vue-rollbar.js.erb'; // eslint-disable-line import/first



document.addEventListener('turbolinks:load', () => {
  const components = [
    {
      element_id: 'sign_in',
      components: { SignIn },
      data: {},
    },
    {
      element_id: 'profile',
      components: { Profile },
      data: {},
    },
    {
      element_id: 'cookie-law',
      components: { CookieLaw },
      data: {},
    },
    {
      element_id: 'leave-site',
      components: { LeaveSite },
      data: {},
    },
  ];

  components.forEach((e) => {
    const element = document.getElementById(e.element_id);
    if (element != null) {
      // eslint-disable-next-line no-unused-vars
      const app = new Vue({
        el: element,
        components: e.components,
        data: e.data,
      });
    }
  });
});

// Make bootstrap-select work with Turbolinks
document.addEventListener('turbolinks:load', () => {
  /* eslint-disable no-undef */
  $(window).trigger('load.bs.select.data-api');
  /* eslint-enable no-undef */
});
