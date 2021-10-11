/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {
    /* State variables
     */

    mapping(address => uint256) private balances;
    mapping(address => bool) public enrolled;
    address public owner = msg.sender;

    /* Events - publicize actions to external listeners
     */

    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint256 amount);
    event LogWithdrawal(
        address accountAddress,
        uint256 withdrawAmount,
        uint256 newBalance
    );

    /* Functions
     */

    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);

        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint256) {
        require(enrolled[msg.sender] = true);
        balances[msg.sender] += msg.value;

        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint256 withdrawAmount) public payable returns (uint256) {
        uint256 balance = balances[msg.sender];

        require(balance >= withdrawAmount);

        // extra ("") indicator represent a null return value. hopefully this gets versioned in solidity updgrade
        (bool success, ) = msg.sender.call.value(withdrawAmount)("");

        if (!success) {
            revert("Unable to withdraw funds.");
        }

        balances[msg.sender] -= withdrawAmount;

        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }
}
