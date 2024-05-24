import { setup } from "./mud/setup";
import mudConfig from "contracts/mud.config";

const {
  components,
  systemCalls: { increment, setVendingMachineRatio },
  network,
} = await setup();

// Components expose a stream that triggers when the component is updated.
components.RatioConfig.update$.subscribe((update) => {
  console.log("update:", update);
});

// Attach the increment function to the html element with ID `incrementButton` (if it exists)
document
  .querySelector("#incrementButton")
  ?.addEventListener("click", increment);

document
  .querySelector("#setVendingMachineRatio")
  ?.addEventListener("click", () => {
    handleSubmit();
  });

document.querySelector("#purchaseItem")?.addEventListener("click", () => {
  handleSubmit();
});
// Vending machine functions
function handleSubmit() {
  console.log("handleSubmit");

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
