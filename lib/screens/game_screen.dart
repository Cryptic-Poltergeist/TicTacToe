import 'package:flutter/material.dart';
import 'package:winnn/provider/room_data_provider.dart';
import 'package:winnn/resources/socket_method.dart';
import 'package:winnn/views/scoreboard.dart';
import 'package:winnn/views/tictactoe_board.dart';
import 'package:winnn/widgets/custom_text.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethod _socketMethod = SocketMethod();

  @override
  void initState() {
    super.initState();
    _socketMethod.updateRoomListener(context);
    _socketMethod.updatePlayersStateListener(context);
    _socketMethod.pointIncreaseListener(context);
    _socketMethod.endGameListener(context);
    _socketMethod.matchResetListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final roomDataProvider = RoomDataProvider.of(context);
    final roomData = roomDataProvider.roomData;
    final roomId = roomData['_id']?.toString() ?? '';
    final isJoin = roomData['isJoin'] == true;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isJoin
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'Waiting for another player...',
                      fontSize: 26,
                    ),
                    const SizedBox(height: 24),
                    SelectableText(
                      roomId,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Scoreboard(),
                    const TicTacToeBoard(),
                    CustomText(
                      text: roomData['turn'] == null
                          ? 'Game ready'
                          : '${roomData['turn']['nickname']}\'s turn',
                      fontSize: 22,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
