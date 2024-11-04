import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_game/components/piece.dart';
import 'package:tetris_game/components/pixel.dart';
import 'package:tetris_game/constant/values.dart';

/*

GAME BOARD

This is a 2x2 grid with null representing an empty space.
A non empty space will have the color to represent the landed pieces 

*/

// create game board
List<List<Tetromino?>> gameBoard =
    List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.T);

  int currentScore = 0;

  bool gameOver = false;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 450);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    timer = Timer.periodic(frameRate, (timer) {
      setState(() {
        // Check landing
        checkLanding();

        // Check if game is over
        if (gameOver == true) {
          print("Cancel Timer");
          timer.cancel();
          showGameOverDialog();
        }

        // Truong hop if để tránh trường hợp gameover rồi. Mà vẫn đi thêm 1 bước nữa.
        if (gameOver == false) {
          print("Down");
          // move current piece down
          currentPiece.movePiece(Direction.down);
        }
      });
    });
  }

  // game over message
  void showGameOverDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AlertDialog(
                  backgroundColor: Colors.grey[900],
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  title: Text(
                    'Game Over',
                    style: TextStyle(color: Colors.orange[800]),
                  ),
                  content: Text("Your score is: $currentScore",
                      style: TextStyle(color: Colors.amber[400])),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        resetGame();

                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.orange[300]!),
                        ),
                        child: const Text("Play Again",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ));
  }

  // reset game
  void resetGame() {
    // clear the game board
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

    // new game
    gameOver = false;
    currentScore = 0;

    // create new piece
    createNewPiece();

    // start the game
    startGame();
  }

  // clear lines
  void clearLines() {
    // step 1: loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row if full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty column, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: If the row is full, clear the row and shift the rows down
      if (rowIsFull) {
        setState(() {
          // step 5: move all rows above the cleared row down by one posotion
          for (int r = row; r > 0; r--) {
            // copy the above row to the current row
            gameBoard[r] = List.from(gameBoard[r - 1]);

            // step 6: set the top row to empty
            gameBoard[0] = List.generate(row, (index) => null);

            // step 7: Increase the score!
          }
          currentScore++;
        });
        // Check tiếp ngay hàng đó chớ không move lên
        row += 1;
      }
    }
  }

  // check for collision in a future posotion
  // return true -> there is a collistion
  // return false -> there is no collistion
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column
      int row = currentPiece.position[i] ~/ rowLength;
      int col = currentPiece.position[i] % rowLength;

      // adjust the row nad col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds
      // (either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
      // check if the pixel already landing
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    // if no collisions are detected, return false
    return false;
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // Clear line
      clearLines();

      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with ramdom type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];

    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
    
    Since our game over condition is if there is a piece at the top level,
    you want to check if the game is over when you create a new piece
    instead of checking every frame, because new piece are alloed to go through the top level

    */
    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void moveDown() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.down)) {
      setState(() {
        currentPiece.movePiece(Direction.down);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // GAME OVER METHOD
  bool isGameOver() {
    // Check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // If the top row is empty
    return false;
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        rotatePiece();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        moveDown();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        moveLeft();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        moveRight();
      }
    }
  }

  // Detect Arrow in Web
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKeyEvent: onKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: 340, 
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowLength),
                      itemCount: rowLength * colLength,
                      itemBuilder: (context, index) {
                        // get row and col of each index
                        int row = index ~/ rowLength;
                        int col = index % rowLength;

                        // current piece
                        if (currentPiece.position.contains(index)) {
                          return Pixel(
                            color: tetrominoColors[currentPiece.type],
                          );
                        } // landed pieces
                        else if (gameBoard[row][col] != null) {
                          return Pixel(
                            color: tetrominoColors[gameBoard[row][col]],
                          );
                        }

                        // blank pixel
                        else {
                          return Pixel(
                            color: Colors.grey[900],
                          );
                        }
                      }),
                ),

                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: moveDown,
                        icon: const Icon(Icons.arrow_downward,
                            size: 50, color: Colors.white),
                        enableFeedback: false,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "SCORE: $currentScore",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: moveDown,
                        icon: const Icon(Icons.arrow_downward,
                            size: 50, color: Colors.white),
                        enableFeedback: false,
                      ),
                    ),
                  ],
                ),

                // GAME CONTROL
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        iconTheme:
                            const IconThemeData(size: 30, color: Colors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // left
                        IconButton(
                          onPressed: moveLeft,
                          icon: const Icon(
                            Icons.keyboard_arrow_left_sharp,
                            size: 60,
                          ),
                          enableFeedback: false,
                        ),
                        // rotate
                        IconButton(
                          onPressed: rotatePiece,
                          icon: const Icon(
                            Icons.rotate_right,
                            size: 60,
                          ),
                          enableFeedback: false,
                        ),
                        // right
                        IconButton(
                          onPressed: moveRight,
                          icon: const Icon(
                            Icons.keyboard_arrow_right_sharp,
                            size: 60,
                          ),
                          enableFeedback: false,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
