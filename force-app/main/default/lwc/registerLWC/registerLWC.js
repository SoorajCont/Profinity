import { api, LightningElement, track } from "lwc";
import register from "@salesforce/apex/MockServerAPI.register";

export default class RegisterLWC extends LightningElement {
  @api recordId;
  @track password;
  @track serverData;

  handleChangePassword(event) {
    this.password = event.target.value;
  }

  handleCreate() {
    if (this.recordId && this.password)
      register({ recordId: this.recordId, password: this.password })
        .then((result) => {
          this.serverData = result;
        })
        .catch((error) => {
          console.error("Error fetching data", error);
          this.serverData = "error";
        });
  }
}
