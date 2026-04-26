import 'package:flutter/material.dart';
import 'package:winnn/resources/socket_method.dart';
import 'package:winnn/responsive/responsive.dart';
import 'package:winnn/widgets/custom_button.dart';
import 'package:winnn/widgets/custom_text.dart';
import 'package:winnn/widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIDController = TextEditingController();
  final SocketMethod _socketMethod = SocketMethod();

  @override
  void initState() {
    super.initState();
    _socketMethod.joinRoomSuccessListener(context);
    _socketMethod.errorOccurredListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIDController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                shadows: [
                  Shadow(
                    blurRadius: 40,
                    color: Color.fromRGBO(163, 97, 255, 1),
                  )
                ],
                text: 'Join Room',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),
              CustomTextfield(
                controller: _nameController,
                hintText: 'Enter your nickname',
              ),
              SizedBox(height: size.height * 0.05),
              CustomTextfield(
                controller: _gameIDController,
                hintText: 'Enter Room ID',
              ),
              SizedBox(height: size.height * 0.05),
              CustomButton(
                onTap: () => _socketMethod.joinRoom(
                  _nameController.text,
                  _gameIDController.text,
                ),
                text: 'Join',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
