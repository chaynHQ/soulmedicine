const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

const VueLoaderPlugin = require('vue-loader/lib/plugin');

const erb = require('./loaders/erb');
const vue = require('./loaders/vue');

environment.loaders.prepend('erb', erb);

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.prepend('vue', vue);

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

module.exports = environment;
