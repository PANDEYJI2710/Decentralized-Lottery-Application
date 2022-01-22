// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.11;

contract Lottery
{
    address public manager;
    address payable[] public participants;
    // payable keyword because we are going to receive ether from partcipants and
    // use of dynamic array becuase we are having address of more than one participants.

    constructor()
    {
        manager = msg.sender;
        // whoever deploy this contract is having sole control of this smart contract.
    }

    receive() external payable
    {
        require(msg.value == 1 ether, "You must atleast pay 2 ether");
        participants.push(payable(msg.sender));
        // push "msg.sender" address to participants dynamic array and payable bacuase 
        // participants is going to pay 2 ether.
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager,"You are not the owner of the smart contract");
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public
    {
        require(msg.sender == manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);

        // used to reset our partcipants address after a winner is announced.
    }

}