import 'package:flutter/material.dart';
import 'package:winnn/provider/room_data_provider.dart';
import 'package:winnn/resources/socket_method.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final SocketMethod _socketMethod = SocketMethod();

  @override
  void initState() {
    super.initState();
    _socketMethod.tappedListener(context);
  }

  void tapped(int index, RoomDataProvider provider) {
    _socketMethod.tapGrid(
      index,
      provider.roomData['_id'],
      provider.displayElements,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = RoomDataProvider.of(context);
    final turn = provider.roomData['turn'];
    final turnSocketId = turn is Map ? turn['socketID'] : null;
    final isMyTurn = turnSocketId == _socketMethod.socketId;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.65,
        maxWidth: 500,
      ),
      child: AbsorbPointer(
        absorbing: !isMyTurn,
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final value = provider.displayElements[index];

            return GestureDetector(
              onTap: () => tapped(index, provider),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                ),
                child: Center(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 86,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 40,
                            color: value == 'O' ? Colors.red : Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
