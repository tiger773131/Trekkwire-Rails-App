/* eslint no-console:0 */

// Rails functionality
import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"

// Make accessible for Electron and Mobile adapters
window.Rails = Rails

require("@rails/activestorage").start()
import "@rails/actiontext"

// ActionCable Channels
import "./channels"

// Stimulus controllers
import "./controllers"

// Jumpstart Pro & other Functionality
import "./src/**/*"
require("local-time").start()

// Start Rails UJS
Rails.start()

window.dispatchMapsEvent = function (...args) {
  const event = new Event("google-maps-callback", { bubbles: true, cancelable: true });
  window.dispatchEvent(event)
}

window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());

gtag('config', 'G-T0GLNCRC2J');
