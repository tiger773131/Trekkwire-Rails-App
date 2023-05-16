import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
let map;
let markers = [];
let marker;

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
    const {Marker} = await google.maps.importLibrary("marker");
    map = new Map(this.mapTarget, {
      center: {lat: 40.7328, lng: -73.9991},
      zoom: 14,
    });
    // listens on drag end event
    map.addListener("drag", () => {
      this.markers = [];
      this.hideMarkers();
    });

    map.addListener("dragend", () => {
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
      console.log(mapBounds)
      // this.fetchAccounts(mapBounds);
      this.fetchAccounts(mapBounds)
    });
  }

  // get new list of accounts from the server within the map bounds
  async fetchAccounts(bounds) {
    markers = [];
    this.hideMarkers();
    fetch(`/map_pins?bounds=${encodeURIComponent(JSON.stringify(bounds))}`)
      .then((response) => response.json())
      .then((data) => {
        console.log(data)
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
      });
  }
  setMapOnAll(theMap) {
    // console.log("set map on all")
    for (var i = 0; i < markers.length; i++) {
      console.log("marker " + markers[i])
      markers[i].setMap(theMap);
      markers[i].setVisible(true);
    }
  }

// Removes the markers from the map, but keeps them in the array.
  hideMarkers() {
    // console.log("hide markers")
    this.setMapOnAll(null);
  }

// Shows any markers currently in the array.
  showMarkers() {
    // console.log("show markers")
    // console.log("markers " + this.markers.length)
    this.setMapOnAll(map);
  }

  addMarker() {
    if (marker) {
      marker.setMap(null);
    }

    // Create a new marker at the center of the map
    marker = new google.maps.Marker({
      position: map.getCenter(),
      map: map
    });

  }
}