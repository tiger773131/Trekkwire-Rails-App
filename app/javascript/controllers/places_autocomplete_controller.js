import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="places-autocomplete"
export default class extends Controller {
  static targets = ["field", "latitude", "longitude"]
  connect() {
    if (typeof (google) != "undefined") {
      this.initPlaces()
    }
    else {
      window.addEventListener("google-maps-callback", () => {
        this.initPlaces()
      })
    }
  }

  async initPlaces() {
    //@ts-ignore
    //setup the autocomplete
    const { Autocomplete } = await google.maps.importLibrary("places");
    this.autocomplete = new Autocomplete(this.fieldTarget, {
      types: ["geocode"],
      });
    this.autocomplete.addListener("place_changed", this.placeChanged.bind(this))
  }

  placeChanged() {
    let place = this.autocomplete.getPlace()
    if (!place.geometry) {
      window.alert("No details available for input: '" + place.name + "'")
      return
    }

    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()
  }
}
