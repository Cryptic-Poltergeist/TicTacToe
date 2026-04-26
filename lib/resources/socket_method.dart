import 'package:flutter/material.dart';
import 'package:winnn/provider/room_data_provider.dart';
import 'package:winnn/resources/game_methods.dart';
import 'package:winnn/resources/socket_client.dart';
import 'package:winnn/screens/game_screen.dart';

class SocketMethod {
  final _socketClient = SocketClient.instance.socket;

  String? get socketId => _socketClient.id;

  void createRoom(String nickname) {
    final trimmedNickname = nickname.trim();

    if (trimmedNickname.isNotEmpty) {
      debugPrint('Emitting createRoom for nickname: $trimmedNickname');
      _socketClient.emit('createRoom', {
        'nickname': trimmedNickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    final trimmedNickname = nickname.trim();
    final trimmedRoomId = roomId.trim();

    if (trimmedNickname.isNotEmpty && trimmedRoomId.isNotEmpty) {
      debugPrint('Emitting joinRoom for room: $trimmedRoomId');
      _socketClient.emit('joinRoom', {
        'nickname': trimmedNickname,
        'roomId': trimmedRoomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index].isEmpty) {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void resetMatch(String roomId) {
    _socketClient.emit('resetMatch', {
      'roomId': roomId,
    });
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.off('createRoomSuccess');
    _socketClient.on('createRoomSuccess', (room) {
      debugPrint(room.toString());
      final roomData = Map<String, dynamic>.from(room);
      final provider = RoomDataProvider.of(context, listen: false);
      provider.updateRoomData(roomData);
      provider.updatePlayer1(Map<String, dynamic>.from(roomData['players'][0]));
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.off('joinRoomSuccess');
    _socketClient.on('joinRoomSuccess', (room) {
      debugPrint(room.toString());
      final roomData = Map<String, dynamic>.from(room);
      final provider = RoomDataProvider.of(context, listen: false);
      provider.updateRoomData(roomData);
      provider.updatePlayer1(Map<String, dynamic>.from(roomData['players'][0]));
      provider.updatePlayer2(Map<String, dynamic>.from(roomData['players'][1]));
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccurredListener(BuildContext context) {
    _socketClient.off('errorOccurred');
    _socketClient.on('errorOccurred', (message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.toString())),
      );
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.off('updatePlayers');
    _socketClient.on('updatePlayers', (players) {
      final provider = RoomDataProvider.of(context, listen: false);
      provider.updatePlayer1(Map<String, dynamic>.from(players[0]));
      provider.updatePlayer2(Map<String, dynamic>.from(players[1]));
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.off('updateRoom');
    _socketClient.on('updateRoom', (room) {
      RoomDataProvider.of(context, listen: false).updateRoomData(
        Map<String, dynamic>.from(room),
      );
    });
  }

  void tappedListener(BuildContext context) {
    _socketClient.off('tapped');
    _socketClient.on('tapped', (data) {
      final provider = RoomDataProvider.of(context, listen: false);
      provider.updateDisplayElements(data['index'], data['choice']);
      provider.updateRoomData(Map<String, dynamic>.from(data['room']));
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.off('pointIncrease');
    _socketClient.on('pointIncrease', (playerData) {
      final provider = RoomDataProvider.of(context, listen: false);
      final player = Map<String, dynamic>.from(playerData);

      if (player['socketID'] == provider.player1.socketID) {
        provider.updatePlayer1(player);
      } else {
        provider.updatePlayer2(player);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.off('endGame');
    _socketClient.on('endGame', (data) {
      final endGameData = Map<String, dynamic>.from(data);
      final winner = Map<String, dynamic>.from(endGameData['winner']);
      final provider = RoomDataProvider.of(context, listen: false);

      provider.updateRoomData(Map<String, dynamic>.from(endGameData['room']));
      provider.updatePlayer1(
        Map<String, dynamic>.from(endGameData['players'][0]),
      );
      provider.updatePlayer2(
        Map<String, dynamic>.from(endGameData['players'][1]),
      );

      GameMethods().showGameDialog(
        context,
        '${winner['nickname']} won the game!',
        canQuit: true,
        onPlayAgain: () => resetMatch(provider.roomData['_id']),
      );
    });
  }

  void matchResetListener(BuildContext context) {
    _socketClient.off('matchReset');
    _socketClient.on('matchReset', (data) {
      final resetData = Map<String, dynamic>.from(data);
      RoomDataProvider.of(context, listen: false).resetMatch(
        Map<String, dynamic>.from(resetData['room']),
        List<dynamic>.from(resetData['players']),
      );
    });
  }
}
