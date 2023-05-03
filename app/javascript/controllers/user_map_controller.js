import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
export default class extends Controller {
  static targets = ["field", "map", "latitude", "longitude"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initializeMap()
    }
  }

  async initializeMap() {
    //@ts-ignore
    const { Map } = await google.maps.importLibrary("maps");

    const map = new Map(this.mapTarget, {
      center: { lat: -34.397, lng: 150.644 },
      zoom: 8,
    });
  }
}