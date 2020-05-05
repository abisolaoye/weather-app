import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../util/utils.dart' as util;
class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => new _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

 String _cityEntered;
   Future _goToNextScreen(BuildContext context) async{
     Map results = await Navigator.of(context).push(
       new MaterialPageRoute<Map>(builder: (BuildContext context){
         return new ChangeCity();
       })
     );
     if (results != null &&  results.containsKey('enter'))
{
 // debugPrint(results["From First Screen" + ['enter'].toString());

_cityEntered = results['enter'];
}   }
  void showStuff() async {
   Map data = await getWeather(util.appId, util.defaultCity);
   print (data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Get Weather Forecast'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed:(){_goToNextScreen(context);} )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.jpg',
              width: 470.0,
              fit: BoxFit.fill,
              height: 1200.0,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0) ,
            child: new Text(
              '${_cityEntered == null ? util.defaultCity: _cityEntered}',
              style: cityStyle(),),

          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.jpg'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: updateTempWidget('_cityEntered'),
          )
          //Container which WILL havev our weather data
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city )async{
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }// this is the method to fetch data from the api
  Widget updateTempWidget(String city ){
    return new FutureBuilder(
       future: getWeather(util.appId, city== null ? util.defaultCity : city  ),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
           if (snapshot.hasData){
             Map content = snapshot.data;
             return new Container(
               child: new  Column(
                 children: <Widget>[
                   new ListTile(
                     title: new Text(content['main']['temp'].toString(),
                     style: new TextStyle(
                 fontStyle: FontStyle.normal,
               fontSize: 49.9,
               color: Colors.white,
               fontWeight: FontWeight.w500
             ),),

                   )
                 ],
               ),
             );
           }
           else {
             return new Container();
           }
        });
  }
}

class ChangeCity extends StatelessWidget
{
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal,
        title: new Text('Change City '),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center (
            child: new Image.asset('images/white_snow.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),

          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City'
                        //this is where user input the city name
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(
                        context, {
                          'enter': _cityFieldController.text
                      }
                      );
                    },
                   textColor: Colors.white70,
                    color: Colors.tealAccent ,
                    child: new Text('Get Weather')),
              )
            ],
          )

        ],
      ),
    );
  }
}






class JSON {
}

TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
  );
}

TextStyle tempStyle(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 40.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500
  );
}