pragma solidity ^0.4.4;


contract Chairs {

    enum State {INITIALIZATION, ACTIVE, FINISHED}

    State public state = State.INITIALIZATION;

    address[] chairs;
    address[] players;
    address public winner;

    uint public bet;
    uint public reward;
    uint public roundNumber = 1;

    function Chairs(uint numberOfPlayers, uint _bet) public {
        require(numberOfPlayers > 1 && _bet >= 0);

        chairs.length = numberOfPlayers - 1;
        bet = _bet;
    }

    function register() public payable {
        require(msg.value == bet && state == State.INITIALIZATION);

        address id = msg.sender;

        require(!alive(id));

        reward += msg.value;
        players.push(id);

        if (players.length == chairs.length + 1)
            state = State.ACTIVE;
    }

    function occupy() public {
        require(state == State.ACTIVE);

        address id = msg.sender;

        require(alive(id) && !seated(id));

        uint index = findChair();

        chairs[index] = id;

        if (chairs.length == 1) {
            finishGame();
        } else if (index == chairs.length - 1) {
            newRound();
        }
    }

    function freeSlots() public view returns (uint) {
        require(state != State.FINISHED);

        if (state == State.INITIALIZATION) {
            return chairs.length + 1 - players.length;
        } else if (state == State.ACTIVE) {
            return chairs.length - findChair();
        }
    }

    function alive(address id) private view returns (bool) {
        for (uint index = 0; index < players.length; index++)
            if (players[index] == id)
                return true;

        return false;
    }

    function seated(address id) private view returns (bool) {
      for (uint index = 0; index < chairs.length; index++)
          if (chairs[index] == id)
            return true;

      return false;
    }

    function findChair() private view returns (uint) {
        for (uint index = 0; index < chairs.length; index++)
            if (!alive(chairs[index]))
                break;

        return index;
    }

    function newRound() private {
        players = chairs;

        delete chairs;

        chairs.length = players.length - 1;
        roundNumber++;
    }

    function finishGame() private {
        state = State.FINISHED;
        winner = chairs[0];
        winner.transfer(reward);
    }

}
