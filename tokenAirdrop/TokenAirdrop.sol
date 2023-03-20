// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

interface ITokenBotva {
    function transfer(address _to, uint256 _amount) external;
    function transferFrom(address _from, address _to, uint256 _amount) external;
}

contract AirdropTokenBotva{

    address public owner;
    
    ITokenBotva public token;

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = ITokenBotva(_tokenAddress);
    }
    
    // DON'T NEED ALLOWANCE
    function airdropTokensFromAirdropBalance(address[] memory _addressArray, uint256[] memory _amountArray) public {
        for (uint256 i = 0; i<_addressArray.length; i++) {
            token.transfer(_addressArray[i], _amountArray[i]);
        }
    }
    
    // NEED ALLOWANCE TO AirdropTokenBotva ADDRESS
    function airdropTokensFromAddressBalance(address[] memory _addressArray, uint256[] memory _amountArray) public {
        for (uint256 i = 0; i<_addressArray.length; i++) {
            token.transferFrom(msg.sender, _addressArray[i], _amountArray[i]);
        }
    }
}