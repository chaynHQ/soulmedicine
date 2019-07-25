<template>
  <cookie-law theme="soulmedicine"></cookie-law>
</template>

<script>
import CookieLaw from 'vue-cookie-law';

export default {
  components: { CookieLaw }
};
</script>

<style>
.Cookie--soulmedicine {
  background: green;
  color: black;
  padding: 1.25em;
}

.Cookie__button {
  background: #f9b632;
  padding: 0.625em 3.125em;
  color: #fff;
  border-radius: 20px;
  border: 0;
  font-size: 1em;
}

.Cookie__button:hover {
  background: #726c;
}
</style>
