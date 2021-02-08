import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:overlay_support/overlay_support.dart';

class MyTimer extends StatefulWidget {
  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Mpulse',
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Color(0xFFE0E0E0),
            leading: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  ),
                ))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Display stop watch time
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Lap time.
              Container(
                height: 120,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });
                    print('Listen records. $value');
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime}',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),

              /// Button
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.black,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                              },
                              child: const Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.black,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                              },
                              child: const Text(
                                'Stop',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Place Holder for Time to start again
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.red,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              _stopWatchTimer.setPresetTime(mSec: 0);
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.green,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                            //   showOverlayNotification((context) {
                            //     return Card(
                            //       margin:
                            //           const EdgeInsets.symmetric(horizontal: 4),
                            //       child: SafeArea(
                            //         child: ListTile(
                            //           leading: SizedBox.fromSize(
                            //               size: const Size(40, 40),
                            //               child: ClipOval(
                            //                   child: Image.asset(
                            //                       "images/logo.jpg"))),
                            //           title: Text('Work Order Submitted'),
                            //           subtitle: Text(
                            //               'Unassigned Work Orders Available.'),
                            //           trailing: IconButton(
                            //               icon: Icon(Icons.close),
                            //               onPressed: () {
                            //                 OverlaySupportEntry.of(context)
                            //                     .dismiss();
                            //               }),
                            //         ),
                            //       ),
                            //     );
                            //   }, duration: Duration(milliseconds: 4000));
                             },
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
