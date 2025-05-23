// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import "../../src/interfaces/IStakeRegistry.sol";
import "../../src/interfaces/IRegistryCoordinator.sol";

/**
 * @title Interface for a `Registry` that keeps track of stakes of operators for up to 256 quorums.
 * @author Layr Labs, Inc.
 */
contract StakeRegistryMock is IStakeRegistry {
    // bitmap returned by the mocked `updateOperatorStake` function
    uint192 updateOperatorStakeReturnBitmap;

    function isOperatorSetQuorum(
        uint8 quorumNumber
    ) external view returns (bool) {}

    function getStakeHistoryLength(
        bytes32 operatorId,
        uint8 quorumNumber
    ) external view returns (uint256) {}

    function setMinimumStakeForQuorum(uint8 quorumNumber, uint96 minimumStake) external {}

    function setSlashableStakeLookahead(uint8 quorumNumber, uint32 lookAheadBlocks) external {}

    function set_updateOperatorStakeReturnBitmap(
        uint192 newValue
    ) external {
        updateOperatorStakeReturnBitmap = newValue;
    }

    function registryCoordinator() external view returns (address) {}

    function initializeDelegatedStakeQuorum(
        uint8 quorumNumber,
        uint96 minimumStake,
        StrategyParams[] memory _strategyParams
    ) external {}

    function initializeSlashableStakeQuorum(
        uint8 quorumNumber,
        uint96 minimumStake,
        uint32 lookAheadPeriod,
        StrategyParams[] memory _strategyParams
    ) external {}

    /**
     * @notice Registers the `operator` with `operatorId` for the specified `quorumNumbers`.
     * @param operator The address of the operator to register.
     * @param operatorId The id of the operator to register.
     * @param quorumNumbers The quorum numbers the operator is registering for, where each byte is an 8 bit integer quorumNumber.
     * @return The operator's current stake for each quorum, and the total stake for each quorum
     * @dev access restricted to the RegistryCoordinator
     * @dev Preconditions (these are assumed, not validated in this contract):
     *         1) `quorumNumbers` has no duplicates
     *         2) `quorumNumbers.length` != 0
     *         3) `quorumNumbers` is ordered in ascending order
     *         4) the operator is not already registered
     */
    function registerOperator(
        address operator,
        bytes32 operatorId,
        bytes memory quorumNumbers
    ) external returns (uint96[] memory, uint96[] memory) {}

    /**
     * @notice Deregisters the operator with `operatorId` for the specified `quorumNumbers`.
     * @param operatorId The id of the operator to deregister.
     * @param quorumNumbers The quorum numbers the operator is deregistering from, where each byte is an 8 bit integer quorumNumber.
     * @dev access restricted to the RegistryCoordinator
     * @dev Preconditions (these are assumed, not validated in this contract):
     *         1) `quorumNumbers` has no duplicates
     *         2) `quorumNumbers.length` != 0
     *         3) `quorumNumbers` is ordered in ascending order
     *         4) the operator is not already deregistered
     *         5) `quorumNumbers` is a subset of the quorumNumbers that the operator is registered for
     */
    function deregisterOperator(bytes32 operatorId, bytes memory quorumNumbers) external {}

    /**
     * @notice Initialize a new quorum created by the registry coordinator by setting strategies, weights, and minimum stake
     */
    function initializeQuorum(
        uint8 quorumNumber,
        uint96 minimumStake,
        StrategyParams[] memory strategyParams
    ) external {}

    /// @notice Adds new strategies and the associated multipliers to the @param quorumNumber.
    function addStrategies(uint8 quorumNumber, StrategyParams[] memory strategyParams) external {}

    /**
     * @notice This function is used for removing strategies and their associated weights from the
     * mapping strategiesConsideredAndMultipliers for a specific @param quorumNumber.
     * @dev higher indices should be *first* in the list of @param indicesToRemove, since otherwise
     * the removal of lower index entries will cause a shift in the indices of the other strategiesToRemove
     */
    function removeStrategies(uint8 quorumNumber, uint256[] calldata indicesToRemove) external {}

    /**
     * @notice This function is used for modifying the weights of strategies that are already in the
     * mapping strategiesConsideredAndMultipliers for a specific
     * @param quorumNumber is the quorum number to change the strategy for
     * @param strategyIndices are the indices of the strategies to change
     * @param newMultipliers are the new multipliers for the strategies
     */
    function modifyStrategyParams(
        uint8 quorumNumber,
        uint256[] calldata strategyIndices,
        uint96[] calldata newMultipliers
    ) external {}

    function delegation() external view returns (IDelegationManager) {}

    function WEIGHTING_DIVISOR() external pure returns (uint256) {}

    function strategyParamsLength(
        uint8 quorumNumber
    ) external view returns (uint256) {}

    /// @notice In order to register for a quorum i, an operator must have at least `minimumStakeForQuorum[i]`
    function minimumStakeForQuorum(
        uint8 quorumNumber
    ) external view returns (uint96) {}

    /// @notice Returns the strategy and weight multiplier for the `index`'th strategy in the quorum `quorumNumber`
    function strategyParamsByIndex(
        uint8 quorumNumber,
        uint256 index
    ) external view returns (StrategyParams memory) {}

    /**
     * @notice This function computes the total weight of the @param operator in the quorum @param quorumNumber.
     * @dev reverts in the case that `quorumNumber` is greater than or equal to `quorumCount`
     */
    function weightOfOperatorForQuorum(
        uint8 quorumNumber,
        address operator
    ) external view returns (uint96) {}

    /**
     * @notice Returns the entire `operatorIdToStakeHistory[operatorId][quorumNumber]` array.
     * @param operatorId The id of the operator of interest.
     * @param quorumNumber The quorum number to get the stake for.
     */
    function getStakeHistory(
        bytes32 operatorId,
        uint8 quorumNumber
    ) external view returns (StakeUpdate[] memory) {}

    function getTotalStakeHistoryLength(
        uint8 quorumNumber
    ) external view returns (uint256) {}

    /**
     * @notice Returns the `index`-th entry in the dynamic array of total stake, `totalStakeHistory` for quorum `quorumNumber`.
     * @param quorumNumber The quorum number to get the stake for.
     * @param index Array index for lookup, within the dynamic array `totalStakeHistory[quorumNumber]`.
     */
    function getTotalStakeUpdateAtIndex(
        uint8 quorumNumber,
        uint256 index
    ) external view returns (StakeUpdate memory) {}

    /// @notice Returns the indices of the operator stakes for the provided `quorumNumber` at the given `blockNumber`
    function getStakeUpdateIndexAtBlockNumber(
        bytes32 operatorId,
        uint8 quorumNumber,
        uint32 blockNumber
    ) external view returns (uint32) {}

    /// @notice Returns the indices of the total stakes for the provided `quorumNumbers` at the given `blockNumber`
    function getTotalStakeIndicesAtBlockNumber(
        uint32 blockNumber,
        bytes calldata quorumNumbers
    ) external view returns (uint32[] memory) {}

    /**
     * @notice Returns the `index`-th entry in the `operatorIdToStakeHistory[operatorId][quorumNumber]` array.
     * @param quorumNumber The quorum number to get the stake for.
     * @param operatorId The id of the operator of interest.
     * @param index Array index for lookup, within the dynamic array `operatorIdToStakeHistory[operatorId][quorumNumber]`.
     * @dev Function will revert if `index` is out-of-bounds.
     */
    function getStakeUpdateAtIndex(
        uint8 quorumNumber,
        bytes32 operatorId,
        uint256 index
    ) external view returns (StakeUpdate memory) {}

    /**
     * @notice Returns the most recent stake weight for the `operatorId` for a certain quorum
     * @dev Function returns an StakeUpdate struct with **every entry equal to 0** in the event that the operator has no stake history
     */
    function getLatestStakeUpdate(
        bytes32 operatorId,
        uint8 quorumNumber
    ) external view returns (StakeUpdate memory) {}

    /**
     * @notice Returns the stake weight corresponding to `operatorId` for quorum `quorumNumber`, at the
     * `index`-th entry in the `operatorIdToStakeHistory[operatorId][quorumNumber]` array if the entry
     * corresponds to the operator's stake at `blockNumber`. Reverts otherwise.
     * @param quorumNumber The quorum number to get the stake for.
     * @param operatorId The id of the operator of interest.
     * @param index Array index for lookup, within the dynamic array `operatorIdToStakeHistory[operatorId][quorumNumber]`.
     * @param blockNumber Block number to make sure the stake is from.
     * @dev Function will revert if `index` is out-of-bounds.
     * @dev used the BLSSignatureChecker to get past stakes of signing operators
     */
    function getStakeAtBlockNumberAndIndex(
        uint8 quorumNumber,
        uint32 blockNumber,
        bytes32 operatorId,
        uint256 index
    ) external view returns (uint96) {}

    /**
     * @notice Returns the total stake weight for quorum `quorumNumber`, at the `index`-th entry in the
     * `totalStakeHistory[quorumNumber]` array if the entry corresponds to the total stake at `blockNumber`.
     * Reverts otherwise.
     * @param quorumNumber The quorum number to get the stake for.
     * @param index Array index for lookup, within the dynamic array `totalStakeHistory[quorumNumber]`.
     * @param blockNumber Block number to make sure the stake is from.
     * @dev Function will revert if `index` is out-of-bounds.
     * @dev used the BLSSignatureChecker to get past stakes of signing operators
     */
    function getTotalStakeAtBlockNumberFromIndex(
        uint8 quorumNumber,
        uint32 blockNumber,
        uint256 index
    ) external view returns (uint96) {}

    /**
     * @notice Returns the most recent stake weight for the `operatorId` for quorum `quorumNumber`
     * @dev Function returns weight of **0** in the event that the operator has no stake history
     */
    function getCurrentStake(
        bytes32 operatorId,
        uint8 quorumNumber
    ) external view returns (uint96) {}

    /// @notice Returns the stake of the operator for the provided `quorumNumber` at the given `blockNumber`
    function getStakeAtBlockNumber(
        bytes32 operatorId,
        uint8 quorumNumber,
        uint32 blockNumber
    ) external view returns (uint96) {}

    /**
     * @notice Returns the stake weight from the latest entry in `_totalStakeHistory` for quorum `quorumNumber`.
     * @dev Will revert if `_totalStakeHistory[quorumNumber]` is empty.
     */
    function getCurrentTotalStake(
        uint8 quorumNumber
    ) external view returns (uint96) {}

    /**
     * @notice Called by the registry coordinator to update an operator's stake for one
     * or more quorums.
     *
     * If the operator no longer has the minimum stake required for a quorum, they are
     * added to the
     */
    function updateOperatorsStake(
        address[] memory operators,
        bytes32[] memory,
        uint8
    ) external pure returns (bool[] memory) {
        return new bool[](operators.length);
    }

    function getMockOperatorId(
        address operator
    ) external pure returns (bytes32) {
        return bytes32(uint256(keccak256(abi.encodePacked(operator, "operatorId"))));
    }

    /// @notice Calculates the individual kick threshold for an operator
    function calculateIndividualKickThreshold(
        uint96 minStake,
        uint32 kickBips,
        uint32 multiplier
    ) external pure returns (uint96) {
        return uint96(uint256(minStake) * kickBips * multiplier / 10000);
    }

    /// @notice Calculates the total kick threshold across all operators
    function calculateTotalKickThreshold(
        uint96 individualThreshold,
        uint32 numOperators
    ) external pure returns (uint96) {
        return uint96(uint256(individualThreshold) * numOperators / 2);
    }

    /// @notice Validates if the churn rate is within acceptable limits
    function validateChurn(
        uint32 currentOperators,
        uint32 newOperators,
        uint32 churnBips
    ) external pure returns (bool) {
        if (currentOperators == 0) {
            return true;
        }

        uint32 maxChurn = uint32(uint256(currentOperators) * churnBips / 10000);
        uint32 actualChurn = currentOperators > newOperators ? currentOperators - newOperators : 0;

        return actualChurn <= maxChurn;
    }
}
