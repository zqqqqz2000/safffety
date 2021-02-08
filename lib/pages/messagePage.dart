import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessagePage();
  }
}

class _MessagePage extends State<MessagePage> {
  List<SmsMessage> messages;
  SmsQuery query = SmsQuery();

  void getMessages() {
    Future<List<SmsMessage>> msms = query.getAllSms;
    msms.then((value) {
      setState(() {
        messages = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (messages == null) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = RefreshIndicator(
          child: ListView(
            children: List.generate(messages.length, (index) {
              SmsMessage message = messages[index];
              return Container(
                margin: EdgeInsets.all(5),
                child: Card(
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  ["发送人", message.sender],
                                  ["具体内容", message.body],
                                  ["发送时间", message.dateSent.toString()],
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
                                    Navigator.pop(context);
                                  },
                                  child: Text("返回")),
                            ],
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.message,
                              size: 32,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.sender,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  message.body,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
          onRefresh: () async {
            getMessages();
          });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("短信拦截"),
      ),
      body: body,
    );
  }
}
