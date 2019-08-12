<template>
  <button
    id="leave-site"
    class="btn btn-secondary btn-lg leave-button"
    @click="leaveSite"
  >
    Leave this site
  </button>
</template>

<script>
export default {
  methods: {
    leaveSite() {
      window.open('http://www.comicrelief.com/', '_newtab');
      window.location.replace(
        'https://www.google.com/search?tbm=isch&q=cute+baby+animal+memes'
      );
    }
  }
};
</script>
