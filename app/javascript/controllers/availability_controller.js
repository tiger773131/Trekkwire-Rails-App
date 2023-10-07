import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="availability"
export default class extends Controller {
  static targets = ["date", "tour_id", "availability_select"]
  change(event) {

    let date = event.target.value
    let tour_id = this.tour_idTarget.value
    let target = this.availability_selectTarget.id
    console.log("Date: " + date)
    console.log("Tour ID: " + tour_id)
    console.log("Target: " + target)

    get(`/scheduled_tours/availability?date=${date}&target=${target}&tour_id=${tour_id}`, {
      responseKind: 'turbo-stream'
    }).then(response => {
      console.log("Response:")
      console.log(response)
    })

  }
}
