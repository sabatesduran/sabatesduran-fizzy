import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button" ]

  connect() {
    this.buttonTargets.forEach(button => this.#showButton(button))
  }

  removeFilter(event) {
    event.preventDefault()
    this.#hideButton(event.target.closest("button"))
  }

  clearCategory({ params: { name } }) {
    this.element.querySelectorAll(`input[name="${name}"]`).forEach(input => this.#hideButton(input.closest("button")))
  }

  #showButton(button) {
    button.querySelector("input").disabled = false
    button.hidden = false
  }

  #hideButton(button) {
    button.querySelector("input").disabled = true
    button.hidden = true
  }
}
