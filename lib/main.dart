import 'package:flutter/material.dart';
import 'package:winnn/provider/room_data_provider.dart';
import 'package:winnn/screens/create_room_screen.dart';
import 'package:winnn/screens/game_screen.dart';
import 'package:winnn/screens/join_room_screen.dart';
import 'package:winnn/screens/main_menu_screen.dart';
// ignore: unused_import
import 'package:winnn/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RoomData(
      notifier: RoomDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 54, 0, 125),
        ),
        routes: {
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
          CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
          GameScreen.routeName: (context) => const GameScreen(),
        },
        initialRoute: MainMenuScreen.routeName,
      ),
    );
  }
}

