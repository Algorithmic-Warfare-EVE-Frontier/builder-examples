import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "AWAR",
  tables: {
    GateAccess: {
      schema: {
        smartObjectId: "uint256",
        corpIds: "uint256[]",
      },
      key: ["smartObjectId"],
    },
  },
});
