import 'package:flutter/material.dart';
import 'package:winnn/provider/room_data_provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = RoomDataProvider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ScoreTile(
          nickname: provider.player1.nickname,
          points: provider.player1.points,
        ),
        _ScoreTile(
          nickname: provider.player2.nickname,
          points: provider.player2.points,
        ),
      ],
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String nickname;
  final double points;

  const _ScoreTile({
    required this.nickname,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            points.toInt().toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
