import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> gameBoard;
  bool isPlayerTurn = true;
  bool gameOver = false;
  String? winner;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    gameBoard = List.filled(9, '');
    isPlayerTurn = true;
    gameOver = false;
    winner = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPlayerTurn ? 'Your turn' : 'Computer\'s turn',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (!gameOver && gameBoard[index] == '') {
                          setState(() {
                            if (isPlayerTurn) {
                              gameBoard[index] = 'X';
                              if (checkWin('X')) {
                                winner = 'Player';
                                gameOver = true;
                              } else if (gameBoard
                                  .every((square) => square != '')) {
                                winner = 'Draw';
                                gameOver = true;
                              } else {
                                isPlayerTurn = false;
                                computerMove();
                              }
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            gameBoard[index],
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: gameBoard[index] == 'X'
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (gameOver)
              Text(
                winner == 'Draw' ? 'It\'s a draw!' : '$winner wins!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  startNewGame();
                });
              },
              child: Text(
                'New Game',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkWin(String player) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    return winConditions.any(
        (condition) => condition.every((index) => gameBoard[index] == player));
  }

  void computerMove() {
    var emptySquares = [];
    for (var i = 0; i < gameBoard.length; i++) {
      if (gameBoard[i] == '') {
        emptySquares.add(i);
      }
    }
    if (emptySquares.isNotEmpty) {
      var randomIndex = Random().nextInt(emptySquares.length);
      var computerMoveIndex = emptySquares[randomIndex];
      gameBoard[computerMoveIndex] = 'O';
      if (checkWin('O')) {
        winner = 'Computer';
        gameOver = true;
      } else if (gameBoard.every((square) => square != '')) {
        winner = 'Draw';
        gameOver = true;
      } else {
        isPlayerTurn = true;
      }
    }
  }
}
