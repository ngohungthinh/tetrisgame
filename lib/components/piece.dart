import 'dart:ui';

import 'package:tetris_game/constant/values.dart';
import 'package:tetris_game/game_board.dart';

class Piece {
  //type of tetris piece
  late Tetromino type;

  Piece({required this.type});

  // the piece is just a list of integers
  late List<int> position;

  // color of tetris piece
  Color get color {
    return tetrominoColors[type]!;
  }

  // generate the integers
  void initializePiece() {
    switch (type) {
      case Tetromino.I:
        position = [-4, -5, -6, -7];
      case Tetromino.L:
        position = [-26, -16, -6, -5];
      case Tetromino.J:
        position = [-25, -15, -6, -5];
      case Tetromino.O:
        position = [-16, -6, -5, -15];
      case Tetromino.S:
        position = [-15, -14, -6, -5];
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
      case Tetromino.T:
        position = [-26, -16, -6, -15];
    }
  }

  // move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        print(position);
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
    }
  }

  // rotate piece
  int rotationState = 1;
  void rotatePiece() {
    // new position
    List<int> newPosition = [];

    // rotate the piece based on it's type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            print("case 0");
            /*
          
            o
            o
            o o
            
            */

            // get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }

          case 1:
            /*
          
            o o o
            o
            
            */

            // get the new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }

          case 2:
            /*
          
            o o
              o
              o
            
            */

            // get the new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }

          case 3:
            /*

                o
            o o o
            
            */

            // get the new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
              o
              o
            o o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            /*
            o
            o o o
            */
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            /*
            o o
              o
              o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            /*
                o
            o o o
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
            o o o o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            /*
            o
            o
            o
            o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            /*
            o o o o
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            /*
            o
            o
            o
            o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.O:
        /*
        The O tetromino does not need to be rotated

        o o
        o o

        */
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
              o o
            o o

            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            /*
            o
            o o 
              o
            */
            newPosition = [
              position[0] - rowLength ,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            /*

              o o
            o o

            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            /*
            o
            o o
              o
            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
            o o
              o o
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            /*
              o
            o o 
            o
            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            /*
            o o
              o o
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            /*
              o
            o o
            o
            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
            o
            o o
            o
            */
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            /*
            o o o
              o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            /*
              o
            o o
              o
            */
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            /*
              o
            o o o
            */
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
        }
    }
  }

  // check if valid position
  bool posotionIsValid(int position) {
    // get the row and col of position
    int row = position ~/ rowLength;
    int col = position % rowLength;

    // if the position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    // otherwise position is valid so return true
    else {
      return true;
    }
  }

  // check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any position is already taken
      if (!posotionIsValid(pos)) {
        return false;
      }

      // get the col of position
      int col = pos % rowLength;

      // check if the first or last column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in ther first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
