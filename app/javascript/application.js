/* eslint no-console:0 */

import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
require("local-time").start()

window.dispatchMapsEvent = function (...args) {
  const event = new Event("google-maps-callback", { bubbles: true, cancelable: true });
  window.dispatchEvent(event)
}

window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());

gtag('config', 'G-T0GLNCRC2J');
import "./channels"
import "./controllers"
import "./src/**/*"
