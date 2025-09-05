// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Phonebook {
    // Add contact struct
    struct Contact {
        string firstName;
        string lastName;
        uint8 age;
        uint256 bankBalance;
    }

    // hash -> data
    // delete hash ->X ""
    mapping(bytes32 => Contact) private contacts;

    // uint8 -> data
    // delete uint8 ->X ""
    mapping(uint8 => Contact) private ageToContact;

    // Add a contact
    function addContact(string memory _fName, string memory _lName, uint8 age, uint256 _startingBalance) external {
        // add checks for empty strings in _fName, _lName
        // add checks for invalid age. age > 0
        // add checks for invalid _startingBalance
        require(bytes(_fName).length > 0, "First name cannot be empty");
        require(bytes(_lName).length > 0, "Last name cannot be empty");
        require(age > 0, "Age must be greater than zero");
        require(_startingBalance > 0, "Starting balance must be positive");
        bytes32 hashedContact = hashContact(_fName, _lName, age);
        contacts[hashedContact] = Contact(_fName, _lName, age, _startingBalance);
        ageToContact[age] = Contact(_fName, _lName, age, _startingBalance);
    }

    // Update a contact info
    function addBalance(bytes32 _hashedContact, uint256 _amount) external  {
        require(_amount > 0, "Zero amount not allowed!");
        contacts[_hashedContact].bankBalance += _amount;
        ageToContact[contacts[_hashedContact].age].bankBalance += _amount;
    }
    function reduceBalance(bytes32 _hashedContact, uint256 _amount) external  {
        // block zero amount
        require(_amount > 0, "Block zero amount");
        // block an attempt to reduce an amount greater than the user balance
        require(_amount <=contacts[_hashedContact].bankBalance, "withdrawal greater tham user balance is not allowed");
        contacts[_hashedContact].bankBalance -= _amount;
        uint8 age = contacts[_hashedContact].age;
        ageToContact[age].bankBalance -= _amount;
     }

    // Read/View a contract
    function viewContact(string memory _fName, string memory _lName, uint8 age) external view returns(Contact memory)  {
        bytes32 hashedContact = hashContact(_fName, _lName, age);
        return contacts[hashedContact];
    }

    function viewContactViaNumber(uint8 _age) external view returns(Contact memory)  {
        return ageToContact[_age];
    }


    // Delete a contact
    function deleteContact(string memory _fName, string memory _lName, uint8 age) external {
        bytes32 contactHash = hashContact(_fName, _lName, age);
        delete contacts[contactHash];
        delete ageToContact[age];

    }

    function hashContact(string memory _fName, string memory _lName, uint8 age) public pure returns(bytes32) {
        return keccak256(abi.encode(_fName, _lName, age));
    }
}




