import 'package:flutter/material.dart';
import '../net/flutterfire.dart';
import 'home_view.dart';


class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
final TextEditingController _emailField = TextEditingController();
final TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Welcome!", 
            style: TextStyle(
              color: Colors.black,
              fontSize: 35
            ),),
            TextFormField(
              controller: _emailField,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                hintText: "example@example.com",
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
            TextFormField(
              controller: _passwordField,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                hintText: "password",
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
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
                    color: const Color(0xffF2E0BD),
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
                    child: const Text(
                      "Register",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xffF2E0BD),
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
                    child: const Text("Log in",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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