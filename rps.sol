// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract SSP{

    //0 - rock
    //1 - paper
    //2 - scissor
    // GameRule[userchoice][gamechoice]
    // 0 - defeat, 1 - draw,  2 - win 


    // 1 BNB = 10^18 wei
    // 1 BNB = 10^9 gwei
    // 0.01 BNB = 10000000 gwei
    // 0.001 BNB = 1000000 gwei
    // 1 bnb = 10^9 gwei
    // minimum is 1000000 gwei or 10^15 wei

    mapping(uint8 => mapping(uint8 => uint8)) GameRules;
    uint256 public minBet = 10e14 wei;


    constructor() payable {
        GameRules[0][0] = 1; // rock draw rock
        GameRules[0][1] = 0; // rock doesn't beat paper
        GameRules[0][2] = 2; // rock beat scissor

        GameRules[1][0] = 2; // paper beat rock
        GameRules[1][1] = 1; // paper draw paper
        GameRules[1][2] = 0; // paper doesn't beat scissor

        GameRules[2][0] = 0; // scissor doesn't beat rock
        GameRules[2][1] = 2; // scissor beat paper
        GameRules[2][2] = 1; // scissor draw scissor

    }

    uint256 private nonce = 0;

    function random() public returns (uint256) {
        nonce++;
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 3;
        return randomNumber;
    }

    event GamePlayed(address userAddress, uint8 result, uint8 _userChoice, uint8 _gameChoice);

    function playGame(uint8 _userChoice) payable public returns (bool){

        require(_userChoice<3, "You can choose only zero, one or two");
        require(address(this).balance >= msg.value*2, "Smart-contract run out of funds");
        require(msg.value >= minBet, "Please, increase your bet, min bet is 0.0001tBNB ");

        uint8 _gamesChoice = uint8(random());
        uint8 result = GameRules[_userChoice][_gamesChoice];

        if (result == 2){
            payable(msg.sender).transfer(msg.value*2);
            emit GamePlayed(msg.sender, 2, _userChoice, _gamesChoice);
            return true;
        } else if (result == 1) {
            payable(msg.sender).transfer(msg.value);
            emit GamePlayed(msg.sender, 1, _userChoice, _gamesChoice);
            return false;
        } else {
            emit GamePlayed(msg.sender, 0, _userChoice, _gamesChoice);
            return false;
        }
    }

    receive() external payable{

    }

}