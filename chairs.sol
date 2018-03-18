pragma solidity ^0.4.0;

contract Chairs {

    enum State {INITIALIZATION, ACTIVE, FINISHED}

    State state = State.INITIALIZATION;

    address[] chairs;
    address[] players;
    address winner;

    uint bet;
    uint reward;
    uint roundNumber = 1;

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

        require(alive(id));

        uint index = find_chair();

        chairs[index] = id;

        if (chairs.length == 1) {
            finish_game();
        } else if (index == chairs.length - 1) {
            new_round();
        }
    }

    function alive(address id) private view returns (bool) {
        for (uint index = 0; index < players.length; index++)
            if (players[index] == id)
                return true;

        return false;
    }

    function find_chair() private view returns (uint) {
        for (uint index = 0; index < chairs.length; index++)
            if (!alive(chairs[index]))
                break;

        return index;
    }

    function new_round() private {
        players = chairs;

        delete chairs;

        chairs.length = players.length - 1;
        roundNumber++;
    }

    function finish_game() private {
        state = State.FINISHED;
        winner = chairs[0];
        winner.transfer(reward);
    }

}
