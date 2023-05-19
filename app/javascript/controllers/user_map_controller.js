import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
let map;
let markers = [];
let marker;
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    if (typeof (google) != "undefined") {
      this.initializeMap()
    }
    else {
      window.addEventListener("google-maps-callback", () => {
        this.initializeMap()
      })
    }
  }


  async initializeMap() {
    //@ts-ignore
    const {Map} = await google.maps.importLibrary("maps");
    map = new Map(this.mapTarget, {
      center: {lat: 40.7328, lng: -73.9991},
      zoom: 8,
    });

    // listens on drag end event
    map.addListener("drag", () => {
      this.hideMarkers();
      this.markers = [];
    });

    map.addListener("idle", () => {
      const bounds = map.getBounds();

      // Extract the necessary information from the bounds object
      const northEast = bounds.getNorthEast();
      const southWest = bounds.getSouthWest();

      const mapBounds = {
        northEastLat: northEast.lat(),
        northEastLng: northEast.lng(),
        southWestLat: southWest.lat(),
        southWestLng: southWest.lng()
      };
      this.fetchAccounts(mapBounds)
      const event = new Event("update-list", { bubbles: true, cancelable: true });
      window.dispatchEvent(event)

    });
  }

  // get new list of accounts from the server within the map bounds
  async fetchAccounts(bounds) {
    fetch(`/map_pins?bounds=${encodeURIComponent(JSON.stringify(bounds))}`)
      .then((response) => response.json())
      .then((data) => {
        data.forEach(function(location) {
          var coordinatesLat = parseFloat(location.operating_location.latitude);
          var coordinatesLong = parseFloat(location.operating_location.longitude);
          const marker = new google.maps.Marker({
            position: { lat: coordinatesLat, lng: coordinatesLong },
            title: "test"
          });
          markers.push(marker)
        });
        this.showMarkers();
        const event = new Event("update-guide-list", { bubbles: true, cancelable: true });
        window.dispatchEvent(event)
      });
  }
  setMapOnAll(theMap) {
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(theMap);
      markers[i].setVisible(true);
    }
  }

// Removes the markers from the map, but keeps them in the array.
  hideMarkers() {
    this.setMapOnAll(null);
  }

// Shows any markers currently in the array.
  showMarkers() {
    this.setMapOnAll(map);
  }

  testOne() {
    // console.log("test one")
  }

  reload() {
    // console.log("reload")
    // Turbo.visit("/page_list", { action: "reload", target: "guides",
    // });
  }
}