import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfleScreen extends StatefulWidget {
  
  @override
  _ProfleScreenState createState() => _ProfleScreenState();
}

class _ProfleScreenState extends State<ProfleScreen> {

  Map<String, double> data = new Map();
  bool _loadChart = false;
  String buttonText = "Click to Show Chart";
  var res;
  
  @override
  void initState() {
    res = getSharedPref();
    data.addAll({
      'ATTENDED': 35,
      'ABSENCE': 7,
    });
  }
  List<Color> _colors = [
    Colors.green,
    Colors.redAccent
  ];

  getSharedPref() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String res = prefs.get("signin_response");
  String headers = prefs.get("signin_headers");
  var jsonHeaders = json.decode(headers);
  var jsonRes = json.decode(res);
  print(jsonRes);

  return jsonRes;
  
  }

  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'assets/profile_assets/chris.jpg',
              child: Container(
                height: 125.0,
                width: 125.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(62.5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/profile_assets/youssef.jpeg'))),
              ),
            ),
            SizedBox(height: 25.0),
            Text(
              'Youssef Khaled',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Third Year, G-3',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '18',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'ATTENDED',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '5',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                        ),                 
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'ABSENCE',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '7',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'PARTICIPATION',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ),
            _loadChart ? PieChart(
              dataMap: data,
              colorList:
                  _colors, // if not declared, random colors will be chosen
              animationDuration: Duration(milliseconds: 1500),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width /
                  2.7, //determines the size of the chart
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200],
              showLegends: true,
              legendPosition:
                  LegendPosition.right, //can be changed to top, left, bottom
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: ChartType.disc, //can be changed to ChartType.ring
            ) : SizedBox(
              height: 150,
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text('${buttonText}', style: TextStyle(
                color: Colors.white
              ),),
              onPressed: () {
                setState(() {
                  _loadChart = !_loadChart;
                  buttonText = _loadChart == false ? "Click to Show Chart" : "Click to Hide Chart";
                });
              },
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 15.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       IconButton(icon: Icon(Icons.table_chart), onPressed: (){},),
            //       IconButton(
            //         icon: Icon(Icons.menu),
            //         onPressed: () {},
            //       )
            //     ],
            //   ),
            // ),
            // buildImages(),
            // buildInfoDetail(),
            // buildImages(),
            // buildInfoDetail(),
          ],
        )
      ],
    );
  }
}


Widget buildImages() {
  return Padding(
    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
    child: Container(
        height: 200.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
                image: AssetImage('assets/profile_assets/beach1.jpg'), fit: BoxFit.cover))),
  );
}

Widget buildInfoDetail() {
  return Padding(
    padding:
        EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Maldives - 12 Days',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 15.0),
            ),
            SizedBox(height: 7.0),
            Row(
              children: <Widget>[
                Text(
                  'Teresa Soto',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Montserrat',
                      fontSize: 11.0),
                ),
                SizedBox(width: 4.0),
                Icon(
                  Icons.timer,
                  size: 4.0,
                  color: Colors.black,
                ),
                SizedBox(width: 4.0),
                Text(
                  '3 Videos',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Montserrat',
                      fontSize: 11.0),
                )
              ],
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 7.0),
            InkWell(
              onTap: () {},
              child: Container(
                height: 20.0,
                width: 20.0,
                child: Image.asset('assets/profile_assets/navarrow.png'),
              ),
            ),
            SizedBox(width: 7.0),
            InkWell(
              onTap: () {},
              child: Container(
                height: 20.0,
                width: 20.0,
                child: Image.asset('assets/profile_assets/chatbubble.png'),
              ),
            ),
            SizedBox(width: 7.0),
            InkWell(
              onTap: () {},
              child: Container(
                height: 22.0,
                width: 22.0,
                child: Image.asset('assets/profile_assets/fav.png'),
              ),
            )
          ],
        )
      ],
    ),
  );
}
