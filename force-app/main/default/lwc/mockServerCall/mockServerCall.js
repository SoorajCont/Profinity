import { LightningElement, track } from "lwc";
import getMockServerById from "@salesforce/apex.MockServerGetRecord.getMockServerById";

export default class MockServerCall extends LightningElement {
  @track recordId;
  @track serverData;

  handleIdChange(event) {
    this.recordId = event.target.value;
  }

  handleFetch() {
    if (this.recordId) {
      getMockServerById({ recordId: this.recordId })
        .then((result) => {
          this.serverData = result;
        })
        .catch((error) => {
          console.error("Error fetching data", error);
        });
    }
  }
}
