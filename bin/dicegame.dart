import 'dart:math';
import 'dart:io';

void main(List<String> arguments) {
  print("\n\n\n-------------------- DICE GAME --------------------\n\n\n");
  Game game = Game();
  int numPlayers = inputNumber("Please enter number of players (2-5): ");

  for (int i = 0; i < numPlayers; i++) {
    String name = inputString("Please enter name of player number ${i + 1}: ");
    game.addPlayer(Player(name));
  }

  while (true) {
    Player? winner = game.nextRound();
    if (winner != null) {
      print("\n${winner.name} has won the game with ${winner.score} points!");
      break;
    }
  }
}

String inputString(String message) {
  while (true) {
    print(message);
    String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    } else {
      print("Input cannot be empty.");
    }
  }
}

int inputNumber(String message) {
  while (true) {
    String input = inputString(message);
    int? number = int.tryParse(input);
    if (number != null && number >= 2 && number <= 5) return number;
    print("Invalid input. Please enter a number between 2 and 5.");
  }
}

class Player {
  String name;
  int score = 0;

  Dice dice1 = Dice();
  Dice dice2 = Dice();

  Player(this.name);

  bool throwDices() {
    int firstNumber = dice1.roll();
    int secondNumber = dice2.roll();
    print("$name rolls: $firstNumber and $secondNumber");

    if (firstNumber == 1 && secondNumber == 1) {
      score = 0;
      print("Both dice are 1! $name loses ALL points!");
      return false;
    } else if (firstNumber == 1 || secondNumber == 1) {
      print("One die is 1! $name loses this turn's points.");
      return false;
    } else {
      int gained = firstNumber + secondNumber;
      score += gained;
      print("$name gains $gained points (total: $score)");
      return true;
    }
  }
}

class Dice {
  int roll() {
    var rng = Random();
    return rng.nextInt(6) + 1;
  }
}

class Game {
  List<Player> players = <Player>[];
  int winScore = 100;

  void addPlayer(Player player) {
    players.add(player);
  }

  bool playerWin(Player player) => player.score >= winScore;

  Player? nextRound() {
    for (Player player in players) {
      print("\n--- ${player.name}'s turn ---");
      bool continueTurn = true;

      while (continueTurn) {
        continueTurn = player.throwDices();

        if (playerWin(player)) {
          return player;
        }

        if (continueTurn) {
          print("Do you want to roll again? (y/n)");
          String? choice = stdin.readLineSync();
          if (choice == null || choice.toLowerCase() != "y") {
            continueTurn = false;
          }
        }
      }
    }
    return null;
  }
}
