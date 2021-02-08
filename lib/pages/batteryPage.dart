import 'package:app_settings/app_settings.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatteryPage extends StatelessWidget {
  Widget _getChargeTime(AndroidBatteryInfo data) {
    if (data.chargingStatus == ChargingStatus.Charging) {
      return data.chargeTimeRemaining == -1
          ? Text("充电中")
          : Text("充电时间剩余: "
              "${(data.chargeTimeRemaining / 1000 / 60).truncate()} "
              "分钟");
    }
    return Text("电池充满或未连接充电器");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AndroidBatteryInfo>(
        future: BatteryInfoPlugin().androidBatteryInfo,
        builder:
            (BuildContext context, AsyncSnapshot<AndroidBatteryInfo> snapshot) {
          if (snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/icons/battery.png',
                          width: 150,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "电池容量",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${(snapshot.data.voltage)} mV",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "充电状态",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "${(snapshot.data.chargingStatus.toString().split(".")[1])}"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "当前电量",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${(snapshot.data.batteryLevel)} %"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "电池种类",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${(snapshot.data.technology)} "),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  _getChargeTime(snapshot.data),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //横轴三个子widget
                          childAspectRatio: 1.5 //宽高比为1时，子widget
                          ),
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "存在电池",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${snapshot.data.present ? "存在" : "不存在"} "),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "电池尺寸",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${(snapshot.data.scale)} "),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "剩余电量",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                "${(-(snapshot.data.remainingEnergy * 1.0E-9)).toStringAsFixed(2)}"
                                "瓦时"),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "电池健康",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(snapshot.data.health),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 7),
                    child: OutlineButton(
                      onPressed: () {
                        AppSettings.openBatteryOptimizationSettings();
                      },
                      child: Text("电池优化"),
                    ),
                  )
                ],
              ),
            );
          return CircularProgressIndicator();
        });
  }
}
