import 'package:chatapp/pages/roomspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(flex: 30, child: SizedBox()),
              Expanded(
                flex: 40,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    child: TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15),
                                        hintText: "Username",
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.length < 2) {
                                          return "Please enter a valid name";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(
                                          color: Colors.white, width: 1)),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width / 1.5,
                                      MediaQuery.of(context).size.height / 10),
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: HexColor("#141d26"),
                                      fontSize: 35,
                                      fontWeight: FontWeight.w300),
                                ),
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    await _storage.write(
                                        key: "username",
                                        value: _nameController.text);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RoomsPage()),
                                        (route) => false);
                                  }
                                },
                              ),
                              const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(flex: 30, child: SizedBox()),
            ],
          ),
        ),
      ),
      backgroundColor: HexColor("#141d26"),
    );
  }
}
