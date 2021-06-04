import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Poker Hand'),
          ),
          body: PokerPage(),
          backgroundColor: Colors.red,
      ),
    );
  }
}

class PokerPage extends StatefulWidget {
  @override
  _PokerPageState createState() => _PokerPageState();
}

class _PokerPageState extends State<PokerPage> {
  final List<String> cardImages = [
    '2C', '2D', '2H', '2S', // 0 - 3
    '3C', '3D', '3H', '3S', // 4 - 7
    '4C', '4D', '4H', '4S', // 8 - 11
    '5C', '5D', '5H', '5S', // 12 - 15
    '6C', '6D', '6H', '6S', // 16 - 19
    '7C', '7D', '7H', '7S', // 20
    '8C', '8D', '8H', '8S', // 24
    '9C', '9D', '9H', '9S', // 28
    '10C', '10D', '10H', '10S', // 32
    'JC', 'JD', 'JH', 'JS', // 36
    'QC', 'QD', 'QH', 'QS', // 40
    'KC', 'KD', 'KH', 'KS', // 44
    'AC', 'AD', 'AH', 'AS' // 48
  ];

  List<int> cardIndices = [ 34, 38, 42, 46, 50 ];
  String thisPokerHand = 'Royal Flush';

  List<String> cardRanks = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];

  getRank(int cardIndex) {
    return cardImages[cardIndex].substring(0, max(0, cardImages[cardIndex].length - 1));
  }
  getSuit(int cardIndex) {
    return cardImages[cardIndex][cardImages[cardIndex].length - 1];
  }
  getRandomCardInt() {
    Random random = new Random();
    return random.nextInt(cardImages.length);
  }

  // notSameCard(cardIndicesList) {
  //   let
  //   for (int i = 0; i < cardIndicesList.length; i++) {
  //
  //   }
  // }
  sortCards(cardIndicesList) {
    cardIndicesList.sort((a, b) => cardRanks.indexOf(getRank(a)).compareTo(cardRanks.indexOf(getRank(b))));
    return cardIndicesList;
  }

  randomizeCards() {
    int newCard = -1;
    List<int> newCardIndices = [-1, -1, -1, -1, -1];
    for (int i = 0; i < 5; i++) {
      while (newCardIndices[i] == -1) {
        newCard = getRandomCardInt();
        if (!newCardIndices.contains(newCard)) {
          newCardIndices[i] = newCard;
        }
      }
    }
    sortCards(newCardIndices);
    setState(() {
      cardIndices = newCardIndices;
      thisPokerHand = determinePokerHand(cardIndices);
    });
  }

  isStraight(cardIndicesList) {
    for (int i = 0; i < 4; i++) {
    if (!(cardRanks.indexOf(getRank(cardIndicesList[i])) - cardRanks.indexOf(getRank(cardIndicesList[i + 1])) == -1) &&
      !(i == 3 && getRank(cardIndicesList[i]) == "5" && getRank(cardIndicesList[i + 1]) == "A")) {
        return false;
      }
    }
    return true;
  }

  isFlush(cardIndicesList) {
    for (int i = 0; i < 4; i++) {
      if (getSuit(cardIndicesList[i]) != getSuit(cardIndicesList[i + 1])) {
        return false;
      }
    }
    return true;
  }

  duplicateChecker(cardIndicesList) {
    List<String> counterList = [];
    List<int> duplicateList = [1,1,1,1,1];

    for (int i = 0; i < 5; i++) {
      if (!counterList.contains(getRank(cardIndicesList[i]))) {
        counterList.add(getRank(cardIndicesList[i]));
      } else {
        duplicateList[counterList.length - 1] += 1;
      }
    }

    duplicateList.sort((a, b) => b - a);
    return duplicateList;
  }

  determinePokerHand(cardIndicesList) {
    if (isStraight(cardIndicesList)) {
      if (isFlush(cardIndicesList)) {
        if (getRank(cardIndicesList[4]) == "A" && getRank(cardIndicesList[3]) == "K") {
          return "Royal Flush";
        } else {
          return "Straight Flush";
        }
      } else {
        return "Straight";
      }
    }
    if (isFlush(cardIndicesList)) {
      return "Flush";
    }
    if (duplicateChecker(cardIndicesList)[0] == 4) {
      return "Four of a Kind";
    }
    if (duplicateChecker(cardIndicesList)[0] == 3) {
      if (duplicateChecker(cardIndicesList)[1] == 2) {
        return "Full House";
      } else {
        return "Three of a Kind";
      }
    }
    if (duplicateChecker(cardIndicesList)[0] == 2) {
      if (duplicateChecker(cardIndicesList)[1] == 2) {
        return "Two Pair";
      } else {
        return "One Pair";
      }
    }
    return "High Card";
  }

  @override
  Widget build(BuildContext context) {
    print(determinePokerHand([0, 4, 8, 12, 48]));
    print(determinePokerHand([21, 25, 29, 33, 37]));
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: (){
              randomizeCards();
            },
            child: Stack(
              children: [
                Container(
                    height: 300,
                    width: 360,
                    color: Colors.black
                ),
                Container(
                  height: 300,
                  width: 200,
                  child: Image.asset('images/${cardImages[cardIndices[0]]}.png')
                ),
                Positioned(
                  left: 40,
                  child: Container(
                    height: 300,
                    width: 200,
                    child: Image.asset('images/${cardImages[cardIndices[1]]}.png')
                  ),
                ),
                Positioned(
                  left: 80,
                  child: Container(
                      height: 300,
                      width: 200,
                      child: Image.asset('images/${cardImages[cardIndices[2]]}.png')
                  ),
                ),
                Positioned(
                  left: 120,
                  child: Container(
                      height: 300,
                      width: 200,
                      child: Image.asset('images/${cardImages[cardIndices[3]]}.png')
                  ),
                ),
                Positioned(
                  left: 160,
                  child: Container(
                      height: 300,
                      width: 200,
                      child: Image.asset('images/${cardImages[cardIndices[4]]}.png')
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40
          ),
          Text(
          '$thisPokerHand',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            color: Colors.white
          ),
        )],
      ),
    );
  }
}