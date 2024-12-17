// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { console } from "forge-std/console.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { CharactersTable } from "@eveworld/world/src/codegen/tables/CharactersTable.sol";
import { GateAccess } from "../codegen/tables/GateAccess.sol";

/**
 * @dev This contract is an example for implementing logic to a smart gate
 */
contract TribeGateSystem is System {
  function canJump(uint256 characterId, uint256 sourceGateId, uint256 destinationGateId) public view returns (bool) {
    // FREEDOM
    // return true;

    // RESTRICTION
    // Get the allowed corp
    uint256[] memory allowedCorps = GateAccess.get(sourceGateId);

    // Get the character corp
    uint256 characterCorp = CharactersTable.getCorpId(characterId);

    for (uint256 i = 0; i < allowedCorps.length; i++) {
      if (characterCorp == allowedCorps[i]) {
        return false;
      }
    }

    return true;
  }

  function addAllowedCorp(uint256 sourceGateId, uint256 corpID) public {
    uint256[] memory oldAllowedCorps = GateAccess.get(sourceGateId);
    uint256[] memory newAllowedCorps = new uint256[](oldAllowedCorps.length + 1);

    for (uint256 i = 0; i < oldAllowedCorps.length; i++) {
      newAllowedCorps[i] = oldAllowedCorps[i];
    }

    newAllowedCorps[oldAllowedCorps.length] = corpID;
    GateAccess.set(sourceGateId, newAllowedCorps);
  }

  function removeAllowedCorp(uint256 sourceGateId, uint256 corpID) public {
    uint256[] memory oldAllowedCorps = GateAccess.get(sourceGateId);
    uint256[] memory newAllowedCorps = new uint256[](oldAllowedCorps.length - 1);

    uint256 newIndex = 0;
    for (uint256 i = 0; i < oldAllowedCorps.length; i++) {
      if (corpID != oldAllowedCorps[i]) {
        newAllowedCorps[newIndex] = oldAllowedCorps[i];
        newIndex++;
      }
    }
    GateAccess.set(sourceGateId, newAllowedCorps);
  }
}
