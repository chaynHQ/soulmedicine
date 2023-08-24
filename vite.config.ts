import { defineConfig } from 'vite';

import erb from 'vite-plugin-erb';
import inject from '@rollup/plugin-inject';
import legacy from '@vitejs/plugin-legacy';
import ViteRails from 'vite-plugin-rails';
import vue from '@vitejs/plugin-vue2';

export default defineConfig({
  plugins: [
    erb(),
    inject({
      $: 'jquery',
      jQuery: 'jquery',
      Popper: ['popper.js', 'default'],
      exclude: 'app/frontend/components/**/*.vue',
    }),
    legacy({
      targets: ['defaults'],
    }),
    ViteRails({
      stimulus: false,
    }),
    vue(),
  ],
});
