import fetchToken from "@salesforce/apex/Proofinity.fetchToken";
import { LightningElement, track } from "lwc";

export default class LayoutComponent extends LightningElement {
  @track response;
  @track code;
  items = [
    { id: 1, name: "Item 1" },
    { id: 2, name: "Item 2" },
    { id: 3, name: "Item 3" }
  ];

  imageUrl = "https://www.example.com/sample-image.jpg";
  handleRedirect() {
    window.open(
      "https://digilocker.meripehchaan.gov.in/public/oauth2/1/authorize?response_type=code&client_id=LF405089BA&state=oidc_flow&redirect_uri=http%3A%2F%2Fcontrivers--dev.sandbox.my.salesforce-sites.com%2Fproofinity&code_challenge=N7MatLVFcTzNyvA3ZQlSeGZHqiX0pMcStgNz00J6Y3U&code_challenge_method=S256&scope=openid",
      "_self"
    );
  }

  async handleFetch() {
    this.code = new URLSearchParams(window.location.search).get("code");
    await fetchToken({ code: this.code })
      .then((response) => {
        console.log(response);
        this.response = response;
      })
      .catch((error) => {
        console.error(error);
      });
  }
}
