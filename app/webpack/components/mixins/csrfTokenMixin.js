const csrfTokenMixin = {
  data() {
    return {
      csrf_token: null
    };
  },
  created() {
    this.csrf_token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');
  }
};

export default csrfTokenMixin;
