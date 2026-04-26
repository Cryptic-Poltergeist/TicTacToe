import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:winnn/provider/room_data_provider.dart';
import 'package:winnn/screens/main_menu_screen.dart';

class GameMethods {
  void checkWinner(BuildContext context, Socket socketClient) {
    final provider = RoomDataProvider.of(context, listen: false);
    final board = provider.displayElements;
    var winner = '';

    const winningPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final position in winningPositions) {
      final first = board[position[0]];
      if (first.isNotEmpty &&
          first == board[position[1]] &&
          first == board[position[2]]) {
        winner = first;
        break;
      }
    }

    if (winner.isEmpty && provider.filledBoxes == 9) {
      showGameDialog(context, 'Draw');
      return;
    }

    if (winner.isEmpty) {
      return;
    }

    final winnerPlayer = provider.player1.playerType == winner
        ? provider.player1
        : provider.player2;

    showGameDialog(context, '${winnerPlayer.nickname} won!');

    if (socketClient.id == winnerPlayer.socketID) {
      socketClient.emit('winner', {
        'winnerSocketId': winnerPlayer.socketID,
        'roomId': provider.roomData['_id'],
      });
    }
  }

  void showGameDialog(
    BuildContext context,
    String text, {
    bool canQuit = false,
    VoidCallback? onPlayAgain,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            if (canQuit)
              TextButton(
                onPressed: () {
                  RoomDataProvider.of(context, listen: false).clearBoard();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainMenuScreen.routeName,
                    (route) => false,
                  );
                },
                child: const Text('Quit'),
              ),
            TextButton(
              onPressed: () {
                onPlayAgain?.call();
                RoomDataProvider.of(context, listen: false).clearBoard();
                Navigator.pop(context);
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
