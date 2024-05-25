import { setup } from "./mud/setup";
import mudConfig from "contracts/mud.config";

const {
  components,
  systemCalls: { setVendingMachineRatio, purchaseItem },
  network,
} = await setup();

// Components expose a stream that triggers when the component is updated.
components.RatioConfig.update$.subscribe((update) => {
  console.log("update:", update);
});

declare let window: any;

document.addEventListener("DOMContentLoaded", () => {
  const connectWalletButton = document.getElementById(
    "connectWallet"
  ) as HTMLButtonElement;
  const disconnectWalletButton = document.getElementById(
    "disconnectWallet"
  ) as HTMLButtonElement;
  const accountAddressDiv = document.getElementById(
    "accountAddress"
  ) as HTMLDivElement;

  connectWalletButton.addEventListener("click", () => {
    if (window.ethereum) {
      // MetaMask is installed
      window.ethereum
        .request({ method: "eth_requestAccounts" })
        .then((accounts: string[]) => {
          if (accounts.length > 0) {
            const userAccount = accounts[0];
            console.log("Connected account:", userAccount);
            accountAddressDiv.textContent = `Account: ${userAccount}`;
            disconnectWalletButton.style.display = "block";
            connectWalletButton.style.display = "none";
          } else {
            console.log("No accounts found");
            accountAddressDiv.textContent = "Account: No accounts found";
          }
        })
        .catch((error: Error) => {
          console.error("Error connecting to MetaMask:", error);
          accountAddressDiv.textContent = "Account: Connection error";
        });
    } else {
      console.log("MetaMask is not installed");
      accountAddressDiv.textContent = "Account: MetaMask not installed";
    }
  });

  disconnectWalletButton.addEventListener("click", () => {
    accountAddressDiv.textContent = "Account: Not connected";
    disconnectWalletButton.style.display = "none";
    connectWalletButton.style.display = "block";
  });
});

document
  .querySelector("#setVendingMachineRatio")
  ?.addEventListener("click", () => {
    handleRatio();
  });

// Vending machine functions
function handleRatio() {
  console.log("handleRatio");

  const ssuId = document.getElementById("ssuId") as HTMLInputElement | any;
  const inventoryInId = document.getElementById("inventoryInId") as
    | HTMLInputElement
    | any;
  const inventoryOutId = document.getElementById("inventoryOutId") as
    | HTMLInputElement
    | any;
  const qtyIn = document.getElementById("qtyIn") as HTMLInputElement | any;
  const qtyOut = document.getElementById("qtyOut") as HTMLInputElement | any;

  console.log(
    "setVendingMachineRatio",
    ssuId.value,
    inventoryInId.value,
    inventoryOutId.value,
    qtyIn.value,
    qtyOut.value
  );

  setVendingMachineRatio(
    ssuId.value,
    inventoryInId.value,
    inventoryOutId.value,
    qtyIn.value,
    qtyOut.value
  );
}

document.querySelector("#purchaseItem")?.addEventListener("click", () => {
  handleItem();
});

// Vending machine functions
function handleItem() {
  console.log("item seller handleItem");
  const smartObjectId = document.getElementById("smartObjectId") as
    | HTMLInputElement
    | any;
  const inventoryItemId = document.getElementById("inventoryInId") as
    | HTMLInputElement
    | any;
  const qty = document.getElementById("qty") as HTMLInputElement | any;
  purchaseItem(smartObjectId.value, inventoryItemId.value, qty.value);
}

// https://vitejs.dev/guide/env-and-mode.html
if (import.meta.env.DEV) {
  const { mount: mountDevTools } = await import("@latticexyz/dev-tools");
  mountDevTools({
    config: mudConfig,
    publicClient: network.publicClient,
    walletClient: network.walletClient,
    latestBlock$: network.latestBlock$,
    storedBlockLogs$: network.storedBlockLogs$,
    worldAddress: network.worldContract.address,
    worldAbi: network.worldContract.abi,
    write$: network.write$,
    recsWorld: network.world,
  });
}
