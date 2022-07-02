import 'package:flutter/material.dart';
import '../net/flutterfire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'authentication.dart';


class RestaurantList extends StatefulWidget {
  final double lat;
  final double lng;
  final String city;
  const RestaurantList({Key? key, required this.city, required this.lat, required this.lng}) : super(key: key);
  @override
  State<RestaurantList> createState() => _RestaurantListState(city, lat, lng);
}

class _RestaurantListState extends State<RestaurantList> {  
  String city;
  double lat;
  double lng;


  late String kGoogleApiKey;

  late  Future<Map<String, dynamic>> restaurants;

  @override
  void initState(){
    super.initState();
     kGoogleApiKey = "AIzaSyCdRIw95oKLxBCr86A_ogK1qo0PPOw4qYA";
     restaurants = _getPlaces();
  }

   Future<Map<String, dynamic>> _getPlaces() async{
    var response = await http.get(Uri.parse(
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat}%2C${lng}&radius=50000&type=restaurant&key=${kGoogleApiKey}'));
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse['results'];
  }

  _RestaurantListState(this.city, this.lat, this.lng);
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
          children: [
            Text("Restaurants near "+city,
            style: const TextStyle(
              fontSize: 35
            ),),
           FutureBuilder <Map<String, dynamic>>(
            future: restaurants,
            builder: (context,  AsyncSnapshot snapshot) {
              switch( snapshot.connectionState){
                case ConnectionState.none:
                  return Text("There is no connection");
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center( child: new CircularProgressIndicator());

                case ConnectionState.done:
                  print(snapshot.hasData);
                  if (snapshot.hasData){
                    Map<String,dynamic>? myMap = snapshot.data; 
                    print('entra');

                    return ListView.builder(
                        itemExtent: 90,
                        itemCount: myMap!.length,
                        itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                              children: <Widget>[
                                 Row(children: [
                                  Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            myMap[index]['icon'],
                                            width: 200,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ))),
                                  Flexible(
                                      child: Text(myMap[index]['name'],
                                          style: const TextStyle(fontSize: 18))),
                                ]),
                                const Divider(color: Colors.black),
                              ],
                            ),
                          );  
                        }
                    );
                  }
                  return Text("No data was loaded");
              }//end switch

            },
          ),
          ],
        ),
      ),
    );
  }
}