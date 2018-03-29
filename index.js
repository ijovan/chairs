var contractDefinition = require("./build/contracts/Chairs.json");
var contract;
var bet;

var Web3 = require("web3");
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

function registration() {
  contract.methods.freeSlots().call((error, freeSlots) => {
    $("#gameProgress").text("Game is currently in registration with " +
      freeSlots + " free slots");
    $("#bet").val(bet);
    $("#registration").show();
  });
}

function newRound() {
  contract.methods.roundNumber().call((error1, roundNumber) => {
    contract.methods.freeSlots().call((error2, freeSlots) => {
      $("#gameProgress").text("Game is currently in round " +
        roundNumber + " with " + freeSlots + " free slots remaining");
      $("#playing").show();
    });
  });
}

function finished() {
  contract.methods.winner().call((error, winner) => {
    $("#gameProgress").text("Game is over. The winner is: " + winner);
  });
}

$("#find").click(() => {
  var contractAddress = $("#contractAddress")[0].value;

  contract = new web3.eth.Contract(contractDefinition.abi, contractAddress);

  contract.methods.state().call((error, state) => {
    if (state == 0) {
      contract.methods.bet().call((error2, _bet) => {
        bet = _bet;
      });

      registration();
      $("#finding").hide();
    } else if (state == 1) {
      newRound();
      $("#finding").hide();
    } else if (state == 2) {
      finished();
      $("#finding").hide();
    }
  });
});

$("#register").click(() => {
  var registrationData = {
    from: $("#registerUserAddress")[0].value,
    value: parseInt($("#bet")[0].value)
  };

  contract.methods.register().send(registrationData, (error) => {
    contract.methods.state().call((error1, state) => {
      if (state == 0) {
        registration();
      } else if (state == 1) {
        newRound();
        $("#registration").hide();
      }
    });
  });
});

$("#occupy").click(() => {
  var occupationData = {
    from: $("#occupyUserAddress")[0].value,
    gas: 200000
  }

  console.log(occupationData);

  contract.methods.occupy().send(occupationData, (error) => {
    console.log(error);
    contract.methods.state().call((error, state) => {
      if (state == 1) {
        newRound();
      } else if (state == 2) {
        finished();
        $("#playing").hide();
      }
    });
  });
});
