import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  late Timer timer;

  void updateTime() async {
    data['timeObject'] = data['timeObject'].add(Duration(seconds: 1));
    setState(() {
      data['time'] = DateFormat.jm().format(data['timeObject']);
      print(data['timeObject']);
    });
  }

  void initTimeUpdate() async {
    try {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        updateTime();
      });
    } catch (e) {
      print('err');
    }
  }

  @override
  void initState() {
    super.initState();
    initTimeUpdate();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    //set background
    String bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
    Color? bgColor = data['isDayTime'] ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/$bgImage'),
          //image: AssetImage('assets/night.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () async {
                  dynamic result =
                      await Navigator.pushNamed(context, '/location');
                  result != null
                      ? setState(() {
                          data['time'] = result['time'];
                          data['location'] = result['location'];
                          data['isDayTime'] = result['isDayTime'];
                          data['flag'] = result['flag'];
                          data['timeObject'] = result['timeObject'];
                        })
                      : null;
                },
                icon: const Icon(Icons.edit_location_rounded),
                label: const Text('Edit Location'),
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                  Colors.grey[300],
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data['location'],
                      style: const TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                data['time'],
                style: const TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
