import 'package:flutter/material.dart';
import 'package:winnn/resources/socket_method.dart';
import 'package:winnn/responsive/responsive.dart';
import 'package:winnn/widgets/custom_button.dart';
import 'package:winnn/widgets/custom_text.dart';
import 'package:winnn/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketMethod _socketMethod = SocketMethod();

  @override
  void initState() {
    super.initState();

    _socketMethod.createRoomSuccessListener(context);
    _socketMethod.errorOccurredListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
                text: 'Create Room',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),
              CustomTextfield(
                controller: _nameController,
                hintText: 'Enter your nickname',
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              CustomButton(
                onTap: () => _socketMethod.createRoom(_nameController.text),
                text: 'Create',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
