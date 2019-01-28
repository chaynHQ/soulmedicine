/* eslint-disable no-unused-vars */
import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import AuthApp from '../components/authentication/app.vue';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#authentication',
    data: {},
    components: {
      AuthApp
    }
  });
  // eslint-disable-next-line prettier/prettier
});
