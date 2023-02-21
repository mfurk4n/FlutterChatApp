import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatBubble extends StatelessWidget {
  final String? from;
  final String? message;
  const ChatBubble({Key? key, this.from, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: HexColor("#141d26"),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                from ?? '',
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.width / 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                message ?? '',
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 21),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
