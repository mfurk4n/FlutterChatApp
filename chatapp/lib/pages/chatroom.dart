import 'package:chatapp/customwidgets/chatbubble.dart';
import 'package:chatapp/models/roommodel.dart';
import 'package:chatapp/pages/roomspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomChat extends StatefulWidget {
  final String? roomname;
  const RoomChat({Key? key, this.roomname}) : super(key: key);

  @override
  _RoomChatState createState() => _RoomChatState();
}

class _RoomChatState extends State<RoomChat> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<List<RoomModel>> response;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<RoomModel> _messages = [];
  late IO.Socket socket;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<List<RoomModel>> oldMessages() async {
    var url = Uri.http("10.0.2.2:3000", "/lastmessages");
    var req = jsonEncode({"data": widget.roomname});
    final response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: req);
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body) as List)
          .map((e) => RoomModel.fromJson(e))
          .toList()
          .cast<RoomModel>();
      return data;
    } else {
      return throw Exception("Hata");
    }
  }

  void initializeSocket() async {
    final username = await storage.read(key: "username");
    socket = IO.io("http://10.0.2.2:3000/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'extraHeaders': {
        'username': username,
        'room': "${widget.roomname}",
      }
    });

    socket.connect();

    socket.on('connect', (data) {});

    socket.on('message', (data) {
      var message = RoomModel.fromJson(data);
      setStateIfMounted(() {
        _messages.add(message);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    response = oldMessages();
    initializeSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
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
            Icons.arrow_back_ios_new,
            size: width / 14,
            color: HexColor("#d0c0a5"),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${widget.roomname}'s Room",
          style: TextStyle(color: HexColor("#d0c0a5"), fontSize: width / 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: width / 12,
              color: HexColor("#d0c0a5"),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RoomsPage()),
                  (route) => false);
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(height / 400),
            child: Container(
              color: HexColor("#d0c0a5"),
              height: height / 400,
            )),
      ),
      body: FutureBuilder<List<RoomModel>>(
          future: response,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _messages = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height / 50,
                    ),
                    Container(
                        height: height * 0.80,
                        decoration: BoxDecoration(
                          color: HexColor("#141d26"),
                          border:
                              Border.all(width: 2, color: HexColor("#d0c0a5")),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: height / 200,
                              ),
                              Flexible(
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    reverse: _messages.isEmpty ? false : true,
                                    itemCount: 1,
                                    shrinkWrap: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        mainAxisAlignment: _messages.isEmpty
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children:
                                                  _messages.map((message) {
                                                return ChatBubble(
                                                    from: message.from,
                                                    message: message.message);
                                              }).toList()),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: HexColor("#d0c0a5"),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#141d26"),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.only(
                                    bottom: 5, left: 5, right: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 8,
                                        controller: _messageController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration:
                                            const InputDecoration.collapsed(
                                          hintText: "Type a message..",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 48,
                                      child: FloatingActionButton(
                                        backgroundColor: HexColor("#d0c0a5"),
                                        onPressed: () async {
                                          if (_messageController.text
                                                  .trim()
                                                  .isNotEmpty &&
                                              _messageController.text.length <=
                                                  700) {
                                            String message =
                                                _messageController.text.trim();
                                            socket.emit(
                                                "message",
                                                RoomModel(
                                                        message: message,
                                                        to: widget.roomname)
                                                    .toJson());
                                            _messageController.clear();
                                          }
                                        },
                                        mini: true,
                                        child: Transform.rotate(
                                            angle: 5.79449,
                                            child: Icon(
                                              Icons.send,
                                              size: 20,
                                              color: HexColor("#141d26"),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
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
          }),
      backgroundColor: HexColor("#141d26"),
    );
  }
}
