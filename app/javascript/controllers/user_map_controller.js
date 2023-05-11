import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initializeMap()
    }
  }

  async initializeMap() {
    //@ts-ignore
    const { Map } = await google.maps.importLibrary("maps");

    const map = new Map(this.mapTarget, {
      center: { lat: 40.7328, lng: -73.9991 },
      zoom: 14,
    });
  }
}