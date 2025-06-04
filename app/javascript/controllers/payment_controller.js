import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "selection", "additionalFields" ]

  connect() {
    this.showAdditionalFields()
  }

  showAdditionalFields() {
    const selection = this.selectionTarget.value
    this.additionalFieldsTargets.forEach((fields) => {
      const show = fields.dataset.type === selection
      fields.hidden = !show
      fields.disabled = !show
    })
  }
}
