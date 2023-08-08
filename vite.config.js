import { defineConfig } from 'vite'

import Erb from 'vite-plugin-erb'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

import { chunkSplitPlugin } from 'vite-plugin-chunk-split';
import inject from '@rollup/plugin-inject';
import gzipPlugin from "rollup-plugin-gzip";
import legacy from '@vitejs/plugin-legacy'
import { resolve } from 'path';
import vue from '@vitejs/plugin-vue2'

export default defineConfig({
  plugins: [
    inject({
      $: 'jquery',
      jQuery: 'jquery',
      Popper: ['popper.js', 'default'],
      exclude: ['**/*.vue']
    }),
    // chunkSplitPlugin({
    //   strategy: 'unbundle',
    // }),
    Erb(),
    FullReload(['config/routes.rb', 'app/views/**/*']),
    RubyPlugin(),
    gzipPlugin(),
    legacy(),
    vue(),
  ],
  resolve: {
    alias: {
      '@components': resolve(__dirname, 'app/webpack/components'),
    },
  },
})
