// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

contract EtherStore {
    error FailedToSendEther();
    error InsufficientBalance();

    mapping(address user => uint256 amount) public _balances;

    function deposit() public payable {
        _balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 balance = _balances[msg.sender];
        if (balance == 0) {
            revert InsufficientBalance();
        }

        (bool sent,) = msg.sender.call{value: balance}("");
        if (!sent) {
            revert FailedToSendEther();
        }

        _balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
