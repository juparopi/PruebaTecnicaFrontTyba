import 'package:flutter/material.dart';
import 'package:flutter_application_1/net/flutterfire.dart';
import 'package:flutter_application_1/ui/home_view.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
TextEditingController _emailField = TextEditingController();
TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: _emailField,
              decoration: const InputDecoration(
                hintText: "example@example.com",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextFormField(
              controller: _passwordField,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "password",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      bool navigate = await register(_emailField.text, _passwordField.text);
                      if( navigate ){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => HomeView()
                          ),
                        );
                      }
                    },
                    child: Text("Register"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      bool navigate = await signIn(_emailField.text, _passwordField.text);
                      if( navigate ){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => HomeView()
                          ),
                        );
                      }
                    },
                    child: Text("Log in"),
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}