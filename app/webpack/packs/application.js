/* eslint-disable no-unused-vars */
import '../stylesheets/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'bootstrap/dist/js/bootstrap';
import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import AuthApp from '../components/authentication/app.vue';

Rails.start();
Vue.use(TurbolinksAdapter);
Turbolinks.start();

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('application');
  if (element != null) {
    const app = new Vue({
      el: element,
      data: {},
      components: {
        AuthApp
      }
    });
  }
  // eslint-disable-next-line prettier/prettier
});
