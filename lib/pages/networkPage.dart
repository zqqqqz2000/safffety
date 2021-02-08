import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:safffety/models/target.dart';
import 'package:wifi_iot/wifi_iot.dart';

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: NetworkPageInner(),
      ),
    );
  }
}

class NetworkPageInner extends StatefulWidget {
  bool _isEnabled;
  bool _isConnected;
  bool _scanStart = false;
  bool _scanDone = false;
  List<Target> addrs = [];

  @override
  State<StatefulWidget> createState() {
    return _NetworkPageInner();
  }
}

class _NetworkPageInner extends State<NetworkPageInner> {
  Stream<NetworkAddress> stream;

  void dispose() {
    print('dispose');
    if (stream != null) stream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WiFiForIoTPlugin.isEnabled().then((val) {
      if (val != null) {
        setState(() {
          widget._isEnabled = val;
        });
      }
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      if (val != null) {
        setState(() {
          widget._isConnected = val;
        });
      }
    });

    if (widget._isEnabled == null || widget._isConnected == null)
      return Center(child: CircularProgressIndicator());
    if (widget._isEnabled) {
      if (widget._isConnected)
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/icons/wifi.png',
                        width: 150,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: WiFiForIoTPlugin.getSSID(),
                            initialData: "Loading..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> ssid) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SSID",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(ssid.data),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: WiFiForIoTPlugin.getBSSID(),
                            initialData: "Loading..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> bssid) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BSSID",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(bssid.data),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: WiFiForIoTPlugin.getCurrentSignalStrength(),
                            initialData: 0,
                            builder: (BuildContext context,
                                AsyncSnapshot<int> signal) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Signal",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(signal.data.toString()),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: WiFiForIoTPlugin.getFrequency(),
                            initialData: 0,
                            builder: (BuildContext context,
                                AsyncSnapshot<int> freq) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Frequency",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(freq.data.toString()),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                FutureBuilder(
                    future: WiFiForIoTPlugin.getIP(),
                    initialData: "Loading..",
                    builder: (BuildContext context, AsyncSnapshot<String> ip) {
                      if (!ip.data.startsWith('Loading') &&
                          !widget._scanStart &&
                          !widget._scanDone) {
                        widget._scanStart = true;
                        widget.addrs = [];
                        final String subnet =
                            ip.data.substring(0, ip.data.lastIndexOf('.'));
                        final List<int> commonPorts = [80, 443, 1433, 139, 635, 1080, 144];
                        for (int port in commonPorts) {
                          stream = NetworkAnalyzer.discover2(subnet, port);
                          stream.listen((NetworkAddress addr) {
                            if (addr.exists) {
                              setState(() {
                                Target target = Target(addr, [port]);
                                bool find = false;
                                for (Target each in widget.addrs) {
                                  if (each.address.ip == addr.ip) {
                                    each.ports.add(port);
                                    find = true;
                                    break;
                                  }
                                }
                                if (!find) widget.addrs.add(target);
                              });
                            }
                          }).onDone(() {
                            setState(() {
                              widget._scanStart = false;
                              widget._scanDone = true;
                            });
                          });
                        }
                      }
                      return Text("当前IP为${ip.data}");
                    }),
                Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    width: double.infinity,
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "扫描网络中的主机 清等待",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                NetworkOtherLoader(widget.addrs, widget._scanStart),
              ]),
        );
      else
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_sharp,
                      size: 60,
                    ),
                    Text("未连接"),
                  ],
                ),
                OutlineButton(
                  onPressed: () {
                    AppSettings.openWIFISettings();
                  },
                  child: Text("连接"),
                )
              ]),
        );
    } else {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 60,
                  ),
                  Text("未启动"),
                ],
              ),
              OutlineButton(
                onPressed: () {
                  WiFiForIoTPlugin.setEnabled(true);
                },
                child: Text("启动"),
              )
            ]),
      );
    }
  }
}

class NetworkOtherLoader extends StatefulWidget {
  List<Target> targets;
  bool scanning;

  NetworkOtherLoader(this.targets, this.scanning);

  @override
  State<StatefulWidget> createState() {
    return _NetworkOtherLoader();
  }
}

class _NetworkOtherLoader extends State<NetworkOtherLoader> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listChild = [];
    if (widget.scanning)
      listChild.add(UnconstrainedBox(child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 5,
          ),
          Text("正在扫描"),
        ],
      )));
    for (Target address in widget.targets)
      listChild.insert(
          0,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 5, //阴影
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  // height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        address.address.ip,
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      Row(
                        children: [Text("开放端口： ")] +
                            address.ports.map((port) {
                              return Text(port.toString() + " ");
                            }).toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    return Expanded(
        child: ListView(
      children: listChild,
    ));
  }
}
