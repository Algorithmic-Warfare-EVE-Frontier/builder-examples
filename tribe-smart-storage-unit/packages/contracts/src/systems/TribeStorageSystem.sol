// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { console } from "forge-std/console.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { System } from "@latticexyz/world/src/System.sol";

import { IERC721 } from "@eveworld/world/src/modules/eve-erc721-puppet/IERC721.sol";
import { InventoryLib } from "@eveworld/world/src/modules/inventory/InventoryLib.sol";
import { InventoryItem } from "@eveworld/world/src/modules/inventory/types.sol";
import { IInventoryErrors } from "@eveworld/world/src/modules/inventory/IInventoryErrors.sol";

import { DeployableTokenTable } from "@eveworld/world/src/codegen/tables/DeployableTokenTable.sol";
import { InventoryItemTable } from "@eveworld/world/src/codegen/tables/InventoryItemTable.sol";
import { EphemeralInvTable } from "@eveworld/world/src/codegen/tables/EphemeralInvTable.sol";
import { EphemeralInvItemTable } from "@eveworld/world/src/codegen/tables/EphemeralInvItemTable.sol";
import { EntityRecordTable, EntityRecordTableData } from "@eveworld/world/src/codegen/tables/EntityRecordTable.sol";
import { EphemeralInvItemTableData, EphemeralInvItemTable } from "@eveworld/world/src/codegen/tables/EphemeralInvItemTable.sol";
import { InventoryItemTableData, InventoryItemTable } from "@eveworld/world/src/codegen/tables/InventoryItemTable.sol";

import { Utils as EntityRecordUtils } from "@eveworld/world/src/modules/entity-record/Utils.sol";
import { Utils as InventoryUtils } from "@eveworld/world/src/modules/inventory/Utils.sol";
import { Utils as SmartDeployableUtils } from "@eveworld/world/src/modules/smart-deployable/Utils.sol";
import { FRONTIER_WORLD_DEPLOYMENT_NAMESPACE } from "@eveworld/common-constants/src/constants.sol";

import { RatioConfig, RatioConfigData } from "../codegen/tables/RatioConfig.sol";
import { TransferItem } from "@eveworld/world/src/modules/inventory/types.sol";
import { Utils as SmartCharacterUtils } from "@eveworld/world/src/modules/smart-character/Utils.sol";
import { CharactersTableData, CharactersTable } from "@eveworld/world/src/codegen/tables/CharactersTable.sol";

/**
 * @dev This contract is an example for extending Inventory functionality from game.
 * This contract implements item trade as a feature to the existing inventoryIn logic
 */
contract TribeStorageSystem is System {
  using InventoryLib for InventoryLib.World;
  using EntityRecordUtils for bytes14;
  using InventoryUtils for bytes14;
  using SmartDeployableUtils for bytes14;
  using SmartCharacterUtils for bytes14;

  InventoryLib.World inventory;

  // TODO define some failure modes.

  modifier isTribesmen(uint256) {
    // TODO checks if the caller is from the same tribe as the SSU owner.

    address tribesmenAddress = _msgSender();
    uint256 tribesmenCharacterId = CharactersByAddressTable.getCharacterId(tribesmenAddress);

    _;
  }

  // NOTE this enables tribesmen to store items loaded in the ephemeral inveotry into the COLLECTIVE inventory
  function deposit(uint256 smartStorageUnitId, uint256[] memory ephemeralInventoryItemIds) public isTribesmen {
    for (uint256 i = 0; i < ephemeralInventoryItemIds.length; i++) {
      uint256 ephemeralInventoryItemId = ephemeralInventoryItemIds[i];

      EphemeralInvItemTableData memory itemToBeDeposited = EphemeralInvItemTable.get(
        smartStorageUnitId,
        ephemeralInventoryItemId,
        _msgSender()
      );
      // TODO grab the quantity
      uint256 ephemeralInventoryItemAmount = itemToBeDeposited.quantity;

      __depositToInventory(ephemeralInventoryItemId, ephemeralInventoryItemAmount, smartStorageUnitId);
    }
  }

  function __depositToInventory(
    uint256 transactionItemId,
    uint256 transactionItemAmount,
    uint256 smartStorageUnitId
  ) private {
    inventory = InventoryLib.World({ iface: IBaseWorld(_world()), namespace: FRONTIER_WORLD_DEPLOYMENT_NAMESPACE });

    address source = _msgSender();
    // address recipient = IERC721(DeployableTokenTable.getErc721Address()).ownerOf(smartStorageUnitId);

    TransferItem[] memory transferItems = new TransferItem[](1);
    transferItems[0] = TransferItem(transactionItemId, source, transactionItemAmount);

    inventory.ephemeralToInventoryTransfer(smartStorageUnitId, transferItems);
  }

  // NOTE this enables tribesmen to loot items from the COLLECTIVE inventory into their ephemeral inventory
  function withdraw(
    uint256 smartStorageUnitId,
    uint256 inventoryItemId,
    uint256 inventoryItemAmount
  ) public isTribesmen {
    __withdrawFromInventory(inventoryItemId, inventoryItemAmount, smartStorageUnitId);
  }

  function __withdrawFromInventory(
    uint256 transactionItemId,
    uint256 transactionItemAmount,
    uint256 smartStorageUnitId
  ) private {
    inventory = InventoryLib.World({ iface: IBaseWorld(_world()), namespace: FRONTIER_WORLD_DEPLOYMENT_NAMESPACE });

    address recepient = _msgSender();
    address source = IERC721(DeployableTokenTable.getErc721Address()).ownerOf(smartStorageUnitId);

    TransferItem[] memory transferItems = new TransferItem[](1);
    transferItems[0] = TransferItem(transactionItemId, source, transactionItemAmount);

    inventory.inventoryToEphemeralTransfer(smartStorageUnitId, recepient, transferItems);
  }
}
