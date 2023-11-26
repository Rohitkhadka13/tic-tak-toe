import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tak_toe/constant/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool winnerFound = false;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String result = '';
  bool oTurn = true;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  List<String> displayXo = ['', '', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int attempts = 0;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );
  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (oTurn && displayXo[index] == '') {
          displayXo[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXo[index] == '') {
          displayXo[index] = 'X';
          filledBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    //1st row check
    if (displayXo[0] == displayXo[1] &&
        displayXo[0] == displayXo[2] &&
        displayXo[0] != '') {
      setState(() {
        result = 'player ${displayXo[0]} wins';
        _updateScore(displayXo[0]);
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
      });
    }
    //2nd row check
    if (displayXo[3] == displayXo[4] &&
        displayXo[3] == displayXo[5] &&
        displayXo[3] != '') {
      setState(() {
        result = 'player ${displayXo[3]} wins';
        _updateScore(displayXo[3]);
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
      });
    }
    //3rd row check
    if (displayXo[6] == displayXo[7] &&
        displayXo[6] == displayXo[8] &&
        displayXo[6] != '') {
      setState(() {
        result = 'player ${displayXo[6]} wins';
        _updateScore(displayXo[6]);
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
      });
    }
    //1st column check
    if (displayXo[0] == displayXo[3] &&
        displayXo[0] == displayXo[6] &&
        displayXo[0] != '') {
      setState(() {
        result = 'player ${displayXo[0]} wins';
        _updateScore(displayXo[0]);
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
      });
    }
    // 2nd column check
    if (displayXo[1] == displayXo[4] &&
        displayXo[1] == displayXo[7] &&
        displayXo[1] != '') {
      setState(() {
        result = 'player ${displayXo[1]} wins';
        _updateScore(displayXo[1]);
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
      });
    }
    // 3rd column check
    if (displayXo[2] == displayXo[5] &&
        displayXo[2] == displayXo[8] &&
        displayXo[2] != '') {
      setState(() {
        result = 'player ${displayXo[2]} wins';
        _updateScore(displayXo[2]);
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
      });
    }
    // diagonal check
    if (displayXo[0] == displayXo[4] &&
        displayXo[0] == displayXo[8] &&
        displayXo[0] != '') {
      setState(() {
        result = 'player ${displayXo[0]} wins';
        _updateScore(displayXo[0]);
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
      });
    }
    // diagonal check
    if (displayXo[2] == displayXo[4] &&
        displayXo[2] == displayXo[6] &&
        displayXo[2] != '') {
      setState(() {
        result = 'player ${displayXo[2]} wins';
        _updateScore(displayXo[2]);
        matchedIndexes.addAll([2, 4, 6]);
        stopTimer();
      });
    }
    if (!winnerFound && filledBoxes == 9) {
      result = "Nobody Wins";
      stopTimer();
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXo[i] = '';
      }
      result = '';
      winnerFound = false;
    });
    filledBoxes = 0;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColor.accentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? "Start" : 'Play Again',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Player O', style: customFontWhite),
                        Text(oScore.toString(), style: customFontWhite),
                      ],
                    ),
                    const SizedBox(width: 21),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Player X', style: customFontWhite),
                        Text(xScore.toString(), style: customFontWhite),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _tapped(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 5, color: MainColor.primaryColor),
                                color: MainColor.secondaryColor),
                            child: Center(
                              child: Text(
                                displayXo[index],
                                style: GoogleFonts.coiny(
                                  textStyle: TextStyle(
                                      fontSize: 64,
                                      color: MainColor.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        result,
                        style: customFontWhite,
                      ),
                      const SizedBox(height: 5),
                      _buildTimer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
