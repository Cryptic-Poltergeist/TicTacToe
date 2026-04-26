import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;

  final String text;
  const CustomButton({Key? key,
   required this.onTap,
   required this.text
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    return  Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(163, 97, 255, 1),
            blurRadius: 20,
            spreadRadius:0,
          )
        ],
      ),

      child: ElevatedButton(
      onPressed:onTap,

      child: Text(text, style:
       const TextStyle(
        fontSize: 19,
        color:  Color.fromRGBO(163, 97, 255, 1),
        )
        ),

      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          width,
          50,
          ),
      ),
      
    )
    );
  }
}