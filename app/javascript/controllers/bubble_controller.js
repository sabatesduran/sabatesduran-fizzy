import { Controller } from "@hotwired/stimulus"
import { signedDifferenceInDays } from "helpers/date_helpers"

const REFRESH_INTERVAL = 3_600_000 // 1 hour (in milliseconds)

export default class extends Controller {
  static targets = [ "entropy", "entropyTop", "entropyDays", "entropyBottom" ]
  static values = { entropy: Object }

  #timer

  connect() {
    this.#timer = setInterval(this.update.bind(this), REFRESH_INTERVAL)
    this.update()
  }

  disconnect() {
    clearInterval(this.#timer)
  }

  update() {
    const closesInDays = signedDifferenceInDays(new Date(), new Date(this.entropyValue.closesAt))

    if (closesInDays > this.entropyValue.daysBeforeReminder) {
      this.#hide()
      return
    }

    this.entropyTopTarget.innerHTML = closesInDays < 1 ? this.entropyValue.action : `${this.entropyValue.action} in`
    this.entropyDaysTarget.innerHTML = closesInDays < 1 ? "!" : closesInDays
    this.entropyBottomTarget.innerHTML = closesInDays < 1 ? "Today" : (closesInDays === 1 ? "day" : "days")

    this.#show()
  }

  #hide() {
    this.element.setAttribute("hidden", "")
  }

  #show() {
    this.element.removeAttribute("hidden")
  }
}
