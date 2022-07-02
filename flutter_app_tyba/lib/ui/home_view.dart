import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/authentication.dart';
import '../net/flutterfire.dart';
import 'package:flutter_application_1/ui/restaurant_list.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';


class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _cityField = TextEditingController();
  
  late GooglePlace googlePlace;
  late String kGoogleApiKey;

  @override
  void initState(){
    super.initState();
    kGoogleApiKey = "AIzaSyCdRIw95oKLxBCr86A_ogK1qo0PPOw4qYA";
    googlePlace = GooglePlace(kGoogleApiKey);
  }

  Future<Map<String, dynamic>> searchCity(String value) async{
    Map<String, dynamic> rta = {};
    var result = await googlePlace.autocomplete.get(value);
    if( result != null && result.predictions != null && mounted){

      String placeId = result.predictions!.first.placeId!;
      var response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${kGoogleApiKey}'));
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      rta = jsonResponse['result']['geometry']['location'];
    }
    return rta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
          Navigator.of(context)
            .pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Authentication()
              ),
            (_) => false,
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.logout),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             const Text("Find restaurants!",
                style: TextStyle(
                  fontSize: 35
                ),
              ),
              TextFormField(
                controller: _cityField,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  hintText: "Type your city here.",
                  hintStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  labelText: "City",
                  labelStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        if(_cityField.text.isNotEmpty){
                          Map<String, dynamic> rta = await searchCity(_cityField.text);
                          try {
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            final now = new DateTime.now();
                            String formatter = DateFormat('yMd').format(now);
                            FirebaseFirestore.instance.collection('Users').doc(uid).collection('Citys').add({"date": formatter, "search": _cityField.text});
                          } catch (e) {
                            print(e);
                          }
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => RestaurantList(city: _cityField.text, lat: rta['lat'] ,lng: rta['lng'])
                              ),
                          );
                        }
                      },
                      child: const Text(
                        "Find",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => RestaurantList(city: "Unknown", lat:position.latitude ,lng: position.longitude)
                            ),
                        );
                      },
                      child: const Text(
                        "Find",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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