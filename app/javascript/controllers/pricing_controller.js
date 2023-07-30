// Options:
//
// Use data-pricing-active="yearly" to select yearly by default

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "toggle", "frequency", "plans" ]
  static values = { frequency: String }
  static classes = ["activeFrequency", "inactiveFrequency", "activePlans", "inactivePlans", "hiddenToggle"]

  connect() {
    this.removeEmptyFrequencies()
    this.defaultFrequency()
  }

  // Switches visible plans
  switch(event) {
    this.frequencyValue = event.target.dataset.frequency
  }

  // Removes frequencies that have no plans in them
  removeEmptyFrequencies() {
    this.frequencyTargets.forEach(target => {
      let frequency = target.dataset.frequency
      let index = this.plansTargets.findIndex((element) => element.dataset.frequency == frequency && element.childElementCount > 0)
      if (index == -1) target.remove()
    })
    this.hiddenToggleClasses.forEach(className => {
      this.toggleTarget.classList.toggle(className, this.frequencyTargets.length < 2)
    })
  }

  defaultFrequency() {
    if (!this.hasFrequencyValue) this.frequencyValue = this.frequencyTargets[0].dataset.frequency
  }

  frequencyValueChanged() {
    this.frequencyTargets.forEach(target => {
      if (target.dataset.frequency == this.frequencyValue) {
        this.showFrequency(target)
      } else {
        this.hideFrequency(target)
      }
    })

    this.plansTargets.forEach(target => {
      if (target.dataset.frequency == this.frequencyValue) {
        this.showPlans(target)
      } else {
        this.hidePlans(target)
      }
    })
  }

  showFrequency(element) {
    element.classList.add(...this.activeFrequencyClass)
    element.classList.remove(...this.inactiveFrequencyClass)
  }

  hideFrequency(element) {
    element.classList.remove(...this.activeFrequencyClass)
    element.classList.add(...this.inactiveFrequencyClass)
  }

  showPlans(element) {
    element.classList.add(...this.activePlansClass)
    element.classList.remove(...this.inactivePlansClass)
  }

  hidePlans(element) {
    element.classList.remove(...this.activePlansClass)
    element.classList.add(...this.inactivePlansClass)
  }
}
