//SPDX-License-Identifier: MIT

// contracts/BuyMeACoffee.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BuyMeACoffeeModified is Ownable {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable payee;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        // First time the payee will be the owner
        payee = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    function changePayee(address _payee) external onlyOwner {
        payee = payable(_payee);
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    function buyLargeCoffee(string memory _name, string memory _message) public payable {
        require(msg.value == (0.003 ether), "Large cofee costs 0.003!");
        buyCoffee(_name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(payee.send(address(this).balance));
    }
}
