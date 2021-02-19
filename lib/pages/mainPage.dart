import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safffety/pages/appPage.dart';
import 'package:safffety/pages/messagePage.dart';
import 'package:safffety/pages/networkPage.dart';

import 'batteryPage.dart';

class MainPage extends StatefulWidget {
  bool bannerPage = true;
  bool startCount = false;
  int countDown = 3;
  int currentIndex = 0;
  List<Widget> pages = [
    BatteryPage(),
    MessagePage(),
    NetworkPage(),
    AppPage(),
  ];

  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Duration timeout = Duration(seconds: 1);
    if (!widget.startCount && widget.bannerPage) {
      widget.startCount = true;
      Timer.periodic(timeout, (timer) {
        if (widget.countDown == 0) {
          setState(() {
            widget.bannerPage = false;
          });
          timer.cancel();
          timer = null;
        } else {
          setState(() {
            widget.countDown--;
          });
        }
      });
    }
    if (widget.bannerPage)
      return Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: TextButton(
                  child: Text('跳过 ' + widget.countDown.toString()),
                  onPressed: () {
                    setState(() {
                      widget.bannerPage = false;
                    });
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Colors.white;
                    }),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Colors.grey[400];
                    }),
                    overlayColor: MaterialStateProperty.all(Colors.grey[400]),
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.grey[400], width: 1)),
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    minimumSize: MaterialStateProperty.all(Size(60, 20)),
                  ),
                ),
              ),
            ),
            Banner()
          ],
        ),
      );
    else
      return Scaffold(
        body: widget.pages[widget.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          type: BottomNavigationBarType.fixed,
          // type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.battery_charging_full), label: '电池情况'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: '短信拦截'),
            BottomNavigationBarItem(
                icon: Icon(Icons.network_cell), label: '网络助手'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.bug_report_outlined), label: '病毒扫描'),
            BottomNavigationBarItem(
                icon: Icon(Icons.android_outlined), label: '应用管理'),
          ],
          onTap: (index) {
            if (widget.currentIndex != index)
              setState(() {
                widget.currentIndex = index;
              });
          },
        ),
      );
  }
}

class Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: Center(
            child: Icon(
              Icons.screen_lock_portrait_outlined,
              size: 200,
            ),
          ),
        )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Text(
                "Safffety",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
              ),
              Text(
                "您的手机安全管家",
                style: TextStyle(color: Colors.grey[500]),
              )
            ],
          ),
        ),
        Text("copyright@2021 上海电力大学")
      ],
    );
  }
}
