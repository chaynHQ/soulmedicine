const csrfTokenMixin = {
  data() {
    return {
      csrfToken: null
    };
  },
  created() {
    this.csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');
  }
};

export default csrfTokenMixin;
