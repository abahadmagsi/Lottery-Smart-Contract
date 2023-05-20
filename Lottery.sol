// Define the version of Solidity to use
pragma solidity ^0.8.0;

// Define the Lottery contract
contract Lottery {
    // Set the minimum number of players required to play the lottery
    uint public constant MIN_PLAYERS = 3;
    
    // Define a variable to store the manager of the contract
    address public manager;
    
    // Define a variable to store the current list of players
    address[] public players;
    
    // Define the constructor function, which will be called once when the contract is deployed
    constructor() {
        // Set the manager to be the account that deployed the contract
        manager = msg.sender;
    }
    
    // Define the enter function, which allows players to enter the lottery by sending 0.1 ether to the contract
    function enter() public payable {
        // Require that the amount sent is exactly 0.1 ether
        require(msg.value == 0.1 ether);
        
        // Add the player's address to the list of players
        players.push(msg.sender);
    }
    
    // Define the pickWinner function, which allows the manager to pick a winner at random and transfer the entire balance of the contract to that winner
    function pickWinner() public {
        // Require that the caller of the function is the manager
        require(msg.sender == manager);
        
        // Require that there are at least MIN_PLAYERS players in the lottery
        require(players.length >= MIN_PLAYERS);
        
        // Generate a random index based on the current block timestamp and the number of players
        uint index = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length))) % players.length;
        
        // Transfer the entire balance of the contract to the winner
        payable(players[index]).transfer(address(this).balance);
        
        // Reset the list of players
        players = new address[](0);
    }
    
    // Define the getPlayers function, which allows anyone to view the current list of players
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}