import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  insertEmoji(event) {
    const emojiChar = event.target.getAttribute("data-emoji")
    const inputVal = this.inputTarget.value
    this.inputTarget.value = `${inputVal}${emojiChar}`
  }
}
