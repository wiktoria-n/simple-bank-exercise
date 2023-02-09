/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

   mapping (address => uint) private balances ;
    
    mapping (address => bool) private enrolled;

    address public owner = msg.sender;

    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amountDeposited);

    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    fallback () external {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      if(!enrolled[msg.sender]) {
        enrolled[msg.sender] = true;
        balances[msg.sender] = 0;
        emit LogEnrolled(msg.sender);
        return true;
      }
      return false;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      require(enrolled[msg.sender]);
      balances[msg.sender] += msg.value;
      emit LogDepositMade(msg.sender, msg.value);

      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      require(enrolled[msg.sender]);
      require(withdrawAmount <= balances[msg.sender]);

      balances[msg.sender] -= withdrawAmount;
      payable(msg.sender).transfer(withdrawAmount);
      emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
      return balances[msg.sender];
    }
}
