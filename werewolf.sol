pragma solidity ^0.4.0;
contract Werewolf {

    enum Phase {REGISTERING, DAY, NIGHT}
    struct Player {
        address id;
        bool voted;
        bool alive;
    }

    Phase phase = Phase.REGISTERING;
    address[] ids;
    mapping(address => Player) players;
    Player lynch_target;
    uint32 positive_votes;
    uint32 negative_votes;
    uint32 alive_count;

    function Werewolf(uint32 numberOfPlayers) public {
        if (numberOfPlayers <= 0)
            return;

        ids.length = numberOfPlayers;
        alive_count = numberOfPlayers;
    }

    function register() public {
        if (phase != Phase.REGISTERING || players[msg.sender].alive)
            return;

        address id = msg.sender;

        for (uint32 index = 0; index < ids.length; index++) {
            if (!players[ids[index]].alive) {
                ids[index] = id;

                Player storage player = players[id];
                player.id = id;
                player.alive = true;

                if (index == ids.length - 1)
                    phase = Phase.DAY;

                break;
            }
        }
    }

    function propose_lynch(address target_id) public {
        if (phase != Phase.DAY || lynch_target.alive || !players[msg.sender].alive)
            return;

        Player storage target = players[target_id];

        if (target.alive == false)
            return;

        lynch_target = target;
    }

    function cast_lynch_vote(bool vote) public {
        if (phase != Phase.DAY || !lynch_target.alive ||
                !players[msg.sender].alive || players[msg.sender].voted)
            return;

        vote ? positive_votes++ : negative_votes++;

        players[msg.sender].voted = false;

        process_lynch_vote();
    }

    function process_lynch_vote() private {
        if (phase != Phase.DAY ||
                positive_votes + negative_votes != alive_count)
            return;

        if (positive_votes > ids.length / 2) {
            players[lynch_target.id].alive = false;
            alive_count--;
            phase = Phase.NIGHT;
        }

        for (uint32 index; index < ids.length; index++)
            players[ids[index]].voted = false;

        delete lynch_target;
        delete positive_votes;
        delete negative_votes;
    }

}
