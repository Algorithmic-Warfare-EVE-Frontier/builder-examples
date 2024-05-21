// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { EntityRecordData, SmartObjectData, WorldPosition } from "@eveworld/world/src/modules/smart-storage-unit/types.sol";
import { InventoryItem } from "@eveworld/world/src/modules/inventory/types.sol";

/**
 * @title IItemSeller
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IItemSeller {
  function test__createAndAnchorItemSeller(
    uint256 smartObjectId,
    EntityRecordData memory entityRecordData,
    SmartObjectData memory smartObjectData,
    WorldPosition memory worldPosition,
    uint256 fuelUnitVolume,
    uint256 fuelConsumptionPerMinute,
    uint256 fuelMaxCapacity,
    uint256 storageCapacity,
    uint256 ephemeralStorageCapacity
  ) external;

  function test__setItemSellerAcceptedItemTypeId(uint256 smartObjectId, uint256 entityTypeId) external;

  function test__setAllowPurchase(uint256 smartObjectId, bool isAllowed) external;

  function test__setAllowBuyback(uint256 smartObjectId, bool isAllowed) external;

  function test__setERC20PurchasePrice(uint256 smartObjectId, uint256 purchasePriceInWei) external;

  function test__setERC20BuybackPrice(uint256 smartObjectId, uint256 buybackPriceInWei) external;

  function test__setERC20Currency(uint256 smartObjectId, address erc20Address) external;

  function test__itemSellerDepositToInventoryHook(uint256 smartObjectId, InventoryItem[] memory items) external;

  function test__itemSellerEphemeralToInventoryTransferHook(
    uint256 smartObjectId,
    InventoryItem[] memory items
  ) external;

  function test__itemSellerWithdrawFromInventoryHook(uint256 smartObjectId, InventoryItem[] memory items) external;

  function test__itemSellerInventoryToEphemeralTransferHook(
    uint256 smartObjectId,
    InventoryItem[] memory items
  ) external;
}
