import 'dart:convert';
import 'package:chatapp/pages/chatroom.dart';
import 'package:chatapp/models/roomsmodel.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:chatapp/services/httpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<List<RoomsModel>> data;

  Future<List<RoomsModel>> getRooms() async {
    var url = Uri.http("10.0.2.2:3000", "/allrooms");
    final response = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      var cevap = (jsonDecode(response.body) as List)
          .map((e) => RoomsModel.fromJson(e))
          .toList()
          .cast<RoomsModel>();
      return cevap;
    } else {
      return throw Exception("Error!");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getRooms();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double height = screen.size.height;
    final double width = screen.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#141d26"),
        toolbarHeight: height / 15,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            size: width / 14,
            color: HexColor("#d0c0a5"),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          },
        ),
        title: Text(
          "Rooms",
          style: TextStyle(color: HexColor("#d0c0a5"), fontSize: width / 16),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(height / 400),
            child: Container(
              color: HexColor("#d0c0a5"),
              height: height / 400,
            )),
      ),
      body: FutureBuilder<List<RoomsModel>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var rooms = snapshot.data;
            return ListView.builder(
              itemCount: rooms!.length,
              itemBuilder: (context, index) {
                var room = rooms[index];
                return Column(
                  children: [
                    SizedBox(
                      height: height / 50,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RoomChat(
                                      roomname: room.name,
                                    )));
                      },
                      child: Container(
                        height: height / 14,
                        width: width * 0.95,
                        decoration: BoxDecoration(
                          color: HexColor("#141d26"),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: HexColor("#d0c0a5"), spreadRadius: 2),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(width / 70),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " ${room.name}'s room",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.all(width / 70),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.online_prediction,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " ${room.active}",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: width / 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: height / 300,
                    )
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ));
          }
          return Container(
            color: HexColor("#141d26"),
            child: Center(
              child: SizedBox(
                height: 70.0,
                width: 70.0,
                child: CircularProgressIndicator(
                  color: HexColor("#d0c0a5"),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#d0c0a5"),
        onPressed: () async {
          String? username = await storage.read(key: "username");
          var response = await HttpService().postOne(username!, "createroom");
          if (response.statusCode == 200) {
            setState(() {});
          }
        },
        child: Icon(
          Icons.add,
          color: HexColor("#141d26"),
        ),
      ),
      backgroundColor: HexColor("#141d26"),
    );
  }
}
