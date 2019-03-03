/* eslint-disable no-unused-vars */
import '../stylesheets/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'bootstrap/dist/js/bootstrap';
import 'bootstrap-select';
import 'data-confirm-modal';

import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import AuthApp from '../components/authentication/app.vue';

Rails.start();
Turbolinks.start();

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('sign_in');
  if (element != null) {
    const app = new Vue({
      el: element,
      components: {
        AuthApp
      },
      data: {}
    });
  }
});

// Make bootstrap-select work with Turbolinks
document.addEventListener('turbolinks:load', () => {
  $(window).trigger('load.bs.select.data-api'); // eslint-disable-line no-undef
});
