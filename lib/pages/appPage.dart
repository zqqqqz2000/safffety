import 'package:app_settings/app_settings.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:system_settings/system_settings.dart';

class AppPage extends StatefulWidget {
  List<Application> apps;

  @override
  State<StatefulWidget> createState() {
    return _AppPage();
  }
}

class _AppPage extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.apps == null) {
      Future<List<Application>> _apps = DeviceApps.getInstalledApplications(
          includeSystemApps: true, includeAppIcons: true);
      _apps.then((value) {
        value.sort((a, b) {
          int _a = a.systemApp ? 1 : 0;
          int _b = b.systemApp ? 1 : 0;
          return _a - _b;
        });
        setState(() {
          widget.apps = value;
        });
      });
    }
    if (widget.apps != null)
      return Scaffold(
        appBar: AppBar(
          title: Text("应用管理"),
        ),
        body: ListView(
          children: List.generate(widget.apps.length, (index) {
            Application app = widget.apps[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                app.appName + " 应用属性",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    ["应用类别", app.category.toString()],
                                    ["包名", app.packageName],
                                    ["安装包路径", app.apkFilePath],
                                    ["版本号", app.versionCode.toString()],
                                    ["版本名", app.versionName.toString()],
                                    ["应用目录", app.dataDir],
                                  ].map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item[0],
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(item[1]),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      SystemSettings.apps();
                                    }, child: Text("权限管理")),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("返回")),
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.memory(
                            (app as ApplicationWithIcon).icon,
                            height: 40,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      app.appName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  app.systemApp
                                      ? Chip(
                                          label: Text(
                                            "系统组件",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          // padding: EdgeInsets.zero,
                                          // labelPadding: EdgeInsets.zero,
                                        )
                                      : Container(),
                                ],
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 50),
                                child: Text(
                                  'Apk文件: ' + app.apkFilePath,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}
