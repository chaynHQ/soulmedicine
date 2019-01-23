import '../stylesheets/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'bootstrap/dist/js/bootstrap';

Rails.start();
Turbolinks.start();

console.log('Hello World from Webpacker'); // eslint-disable-line
