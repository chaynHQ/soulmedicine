// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig, merge } = require('shakapacker');
const webpack = require('webpack');

const webpackConfig = generateWebpackConfig();

const { VueLoaderPlugin } = require('vue-loader');

const erb = require('./loaders/erb');
const vue = require('./loaders/vue');

module.exports = merge(
  {
    module: {
      rules: [erb, vue]
    },
    plugins: [
      new VueLoaderPlugin(),
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
      })
    ],
    resolve: {
      extensions: ['.css', '.scss', '.vue']
    }
  },
  webpackConfig
);
