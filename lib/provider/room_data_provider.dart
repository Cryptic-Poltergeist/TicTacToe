import 'package:flutter/material.dart';
import 'package:winnn/models/player.dart';

class RoomData extends InheritedNotifier<RoomDataProvider> {
  const RoomData({
    Key? key,
    required RoomDataProvider notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);
}

class RoomDataProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};
  final List<String> _displayElements = ['', '', '', '', '', '', '', '', ''];
  int _filledBoxes = 0;
  Player _player1 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 'X',
  );
  Player _player2 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 'O',
  );

  Map<String, dynamic> get roomData => _roomData;
  List<String> get displayElements => _displayElements;
  int get filledBoxes => _filledBoxes;
  Player get player1 => _player1;
  Player get player2 => _player2;

  static RoomDataProvider of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final roomData = context.dependOnInheritedWidgetOfExactType<RoomData>();
      assert(roomData != null, 'No RoomData found in context');
      return roomData!.notifier!;
    }

    final element = context.getElementForInheritedWidgetOfExactType<RoomData>();
    final roomData = element?.widget as RoomData?;
    assert(roomData != null, 'No RoomData found in context');
    return roomData!.notifier!;
  }

  void updateRoomData(Map<String, dynamic> data) {
    _roomData = data;
    notifyListeners();
  }

  void updatePlayer1(Map<String, dynamic> player1Data) {
    _player1 = Player.fromMap(player1Data);
    notifyListeners();
  }

  void updatePlayer2(Map<String, dynamic> player2Data) {
    _player2 = Player.fromMap(player2Data);
    notifyListeners();
  }

  void updateDisplayElements(int index, String choice) {
    final previousChoice = _displayElements[index];
    _displayElements[index] = choice;
    if (previousChoice.isEmpty && choice.isNotEmpty) {
      _filledBoxes += 1;
    }
    notifyListeners();
  }

  void clearBoard() {
    for (var i = 0; i < _displayElements.length; i++) {
      _displayElements[i] = '';
    }
    _filledBoxes = 0;
    notifyListeners();
  }

  void resetMatch(Map<String, dynamic> room, List<dynamic> players) {
    _roomData = room;

    if (players.isNotEmpty) {
      _player1 = Player.fromMap(Map<String, dynamic>.from(players[0]));
    }

    if (players.length > 1) {
      _player2 = Player.fromMap(Map<String, dynamic>.from(players[1]));
    }

    for (var i = 0; i < _displayElements.length; i++) {
      _displayElements[i] = '';
    }
    _filledBoxes = 0;
    notifyListeners();
  }
}
