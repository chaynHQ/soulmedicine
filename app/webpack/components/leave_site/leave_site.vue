<template>
  <button
    id="leave-site"
    class="btn btn-secondary leave-button"
    @click="leaveSite"
  >
    Leave this site
  </button>
</template>

<script>
import Turbolinks from 'turbolinks';

export default {
  methods: {
    leaveSite() {
      Turbolinks.clearCache();
      Turbolinks.visit('/auth/sign_out');
      window.open('http://www.wikipedia.org/', '_newtab');
      window.location.replace(
        'https://www.google.com/search?tbm=isch&q=cute+baby+animal+memes',
      );
    },
  },
};
</script>
