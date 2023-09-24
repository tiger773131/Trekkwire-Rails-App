import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-map"
import { Turbo } from "@hotwired/turbo-rails"

let map;
let markers = [];
let infowindows = [];
let location;
let guide_document;
let guide_document_src;

export default class extends Controller {
  static targets = ["map", "link", "field", "latitude", "longitude"]

  connect() {
    if (typeof (google) != "undefined") {
      this.geolocate()
      this.initializeMap()
      this.initPlaces()
    }
    else {
      window.addEventListener("google-maps-callback", () => {
        this.geolocate()
        this.initializeMap()
        this.initPlaces()
      })
    }
    document.addEventListener("turbo:frame-missing", (event) => {
      const { detail: { response, visit } } = event;
      event.preventDefault();
      visit(response.url);
    });
  }

  geolocate() {
    if (!navigator.geolocation) {
      this.linkTarget.textContent = "Geolocation is not supported in this browser."
    } else {
      location = navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error.bind(this))
      //let options = {
      //  enableHighAccuracy: false,
      //  timeout: 5000,
      //  maximumAge: 0
      //}
      //navigator.geolocation.watchPosition(this.success.bind(this), this.error.bind(this), options)
    }
  }


  async initializeMap() {
    //@ts-ignore
    const {Map} = await google.maps.importLibrary("maps");
    let center = {lat: 40.7328, lng: -73.9991}
    guide_document = document.querySelector("#guides");
    guide_document_src = guide_document.src;
    if (location) {
      center = {lat: location.coords.latitude, lng: location.coords.longitude}
    }
    map = new Map(this.mapTarget, {
      center: center,
      zoom: 14,
      mapTypeControlOptions: {
        mapTypeIds: [false],
      },
      streetViewControl: false,
      fullscreenControl: false,
      gestureHandling: "greedy",
    });

    // listens on drag end event
    map.addListener("drag", () => {
    });

    map.addListener("click", () => {
        this.hideInfoWindows();
        this.infoWindows = [];
    });

    map.addListener("projection_changed", () => {
      this.hideInfoWindows();
      this.infoWindows = [];
    });

    map.addListener("idle", () => {
      this.hideInfoWindows();
      this.infoWindows = [];
      this.hideMarkers();
      this.markers = [];

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
      if (guide_document.src.includes("page_list")) {
        guide_document.src = guide_document_src + "?bounds=" + encodeURIComponent(JSON.stringify(mapBounds));
      }
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
            title: location.name,
            icon: location.avatar_url,
          });
          const contentString = '<div class="card" style="width: 18rem;">' +
              '<div class="grid grid-cols-3 gap-4">' +
                '<img src="' + location.avatar_url + '" class="card-img-top" alt="...">' +
                '<div class="card-body col-span-2">' +
                  '<h5 class="card-title">' + location.name + '</h5>' +
                  '<p class="card-text">' + location.tagline + '</p>' +
                  '<a href="/public_profile/' + location.id + '" class="mt-2 flex-none rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white btn btn-expanded">View</a>' +
                '</div>' +
                '</div>' +
              '</div>';
            const infowindow = new google.maps.InfoWindow({
                content: contentString,
                disableAutoPan : true
            });
            infowindows.push(infowindow);
            marker.addListener("click", () => {
                infowindow.open({
                    anchor: marker,
                    map,
                });
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

  hideInfoWindows() {
    for (var i = 0; i < infowindows.length; i++) {
      infowindows[i].close();
    }
  }

// Shows any markers currently in the array.
  showMarkers() {
    this.setMapOnAll(map);
    guide_document.reload();
  }

  success(position) {
    // this.linkTarget.textContent = `Latitude: ${position.coords.latitude}, Longitude: ${position.coords.longitude}`
    map.panTo({lat: position.coords.latitude, lng: position.coords.longitude})
  }

  error() {
    this.linkTarget.textContent = "Unable to get your location. Please enable geolocation in your browser."
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
    map.panTo({lat: place.geometry.location.lat(), lng: place.geometry.location.lng()})
  }
}

