import { setup } from "./mud/setup";
import mudConfig from "contracts/mud.config";

const {
  components,
  systemCalls: { purchaseItem },
  network,
} = await setup();

// Components expose a stream that triggers when the component is updated.
components.RatioConfig.update$.subscribe((update) => {
  console.log("update:", update);
});

document.querySelector("#purchaseItem")?.addEventListener("click", () => {
  handleSubmit();
});

// Vending machine functions
function handleSubmit() {
  console.log("item seller handleSubmit");
  const smartObjectId = document.getElementById("smartObjectId") as
    | HTMLInputElement
    | any;
  const inventoryItemId = document.getElementById("inventoryInId") as
    | HTMLInputElement
    | any;
  const qty = document.getElementById("qty") as HTMLInputElement | any;
  //   purchaseItem(smartObjectId.value, inventoryItemId.value, qty.value);
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
