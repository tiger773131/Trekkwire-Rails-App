import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
export default class extends Controller {
  static targets = ["map"]
  connect() {
      this.initGoogleMap();
  }
  async initGoogleMap() {
    const position = {lat: -25.344, lng: 131.031};
    const map = new google.maps.Map(this.mapTarget,
      {
        zoom: 4,
        center: position
      });

    console.log('init google map');
  }
}

