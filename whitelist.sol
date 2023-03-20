// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract DocumentSignature{

    address[] private  whitelist;
    mapping(address => bool) private signatures;

    bool public documentSigned = false;

    address private owner;

    constructor() {
        owner = msg.sender;
        whitelist.push(owner);
    }

    //модификатор для проверки на овнера
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    event addToWhiteListEvent(address, bool);


    // Проверка адреса в белом листе
    function inWhitelist(address searchAddress) public view returns(bool) {
        for (uint i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == searchAddress) {
                return true;
            }
        }
        return false;
    }


    function addToWhiteList(address _address) public onlyOwner{
        //добавить проверку на то, чтобы адресс не был в whitelst
        require(!inWhitelist(_address), "address is yet in the WhiteList!");
        //добавить проверку на то, что документ еще не подписан
        require(!areAllSignaturesCollected(), "Document has signed!");

        whitelist.push(_address);
        signatures[_address] = false;

    }

    // Добавление массива адресов в белый список
    function addArrayToWhitelist(address[] memory addressesToAdd) public onlyOwner { 
        require(!documentSigned, "Document is already signed");

        for (uint i = 0; i < addressesToAdd.length; i++) {
            addToWhiteList(addressesToAdd[i]);
        }
    }

    //проверка был ли подписан документ msg.sender
    function hasSignedDocument(address searchAddress) public view returns (bool) {
        return signatures[searchAddress];
    }

    //все ли адреса из вайтлиста подписали документ
    function areAllSignaturesCollected() public view returns (bool) {
        require(whitelist.length > 0, "Whitelist is empty");
        for (uint i = 0; i < whitelist.length; i++) {
            if (!signatures[whitelist[i]]) {
                return false;
            }
        }
        return true;
    }

    //подписать документ 
    function SignDocument() public {
        require(!areAllSignaturesCollected(), "Document has signed!");
        require(inWhitelist(msg.sender), "address is not in the WhiteList!");
        require(!hasSignedDocument(msg.sender), "You are already signed document");

        signatures[msg.sender] = true;

        if (areAllSignaturesCollected()) {
            documentSigned = true;
        }

    }
    
}