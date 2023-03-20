// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenBotva is ERC20 {

    address public owner;

    uint256 public mintValue = 10e18;

    constructor() ERC20("BOTVA", "BTV") {
        owner = msg.sender;
        _mint(owner, 100 * mintValue);
    }

    function mintTenTokens() external {
        _mint(msg.sender, mintValue);
    }
}