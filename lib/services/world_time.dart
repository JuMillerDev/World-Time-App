import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class WorldTime {
  late String location; //location name for the UI
  late String time; //the time in that location
  late DateTime
      timeObj; // the time in that location in the format that allows to add seconds
  late String flag; //url to country flag
  late String url; //endpoint for getting time
  late bool isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      //make the request
      Response response =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      //print(response.body);
      Map data = jsonDecode(response.body);
      //print(data);

      //get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      // print(datetime);
      //print(offset);

      //create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      //set time property
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
      timeObj = now;
    } catch (e) {
      print('Showing Local Time');
      timeObj = DateTime.now();
      time = DateFormat.jm().format(timeObj);
      isDayTime = timeObj.hour > 6 && timeObj.hour < 20 ? true : false;
    }
  }
}
