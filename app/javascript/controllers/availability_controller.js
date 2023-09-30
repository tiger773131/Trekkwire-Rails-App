import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {

    let date = event.target.value
    console.log("Date: " + date)

    // get('/availability?date=${date}', {
    //     responseKind: "turbo-stream"
    // })
  }
}
