import { defineConfig } from 'vite'

import Erb from 'vite-plugin-erb'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'

import inject from '@rollup/plugin-inject';
import gzipPlugin from "rollup-plugin-gzip";
import legacy from '@vitejs/plugin-legacy'
import vue from '@vitejs/plugin-vue2'

export default defineConfig({
  plugins: [
    inject({
      $: 'jquery',
      jQuery: 'jquery',
      Popper: ['popper.js', 'default'],
      exclude: ['**/*.vue']
    }),
    Erb(),
    FullReload(['config/routes.rb', 'app/views/**/*']),
    RubyPlugin(),
    gzipPlugin(),
    legacy(),
    vue(),
  ],
})
