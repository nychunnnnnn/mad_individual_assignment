import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mad_individual_assignment/main_activity.dart';
import 'package:mad_individual_assignment/leader_board.dart';

class _PlayGame extends State<Play> {
  bool _inactive = true, _startTimerCountdown = false;
  int _readyStartTime = 0, gdNum = lvl + 1, score = 0;
  double _countdownTime = 5.0;
  late int _initialReadyStartTime;
  late Timer timer, startTimer;
  String txt = 'LEVEL $lvl';

  late List<int> moleCondition = List.generate(gdNum * gdNum, (index) => 0);
  late List<int> remaining = List.generate(gdNum * gdNum, (index) => index);
  List<ImageProvider> img = [
    const AssetImage('assets/images/empty_mole.png'),
    const AssetImage('assets/images/mole_3.png'),
    const AssetImage('assets/images/whack_mole3.png')
  ];

  String format(int readyStartTime) {
    if (_readyStartTime == _initialReadyStartTime) {
      return "Ready...";
    } else if (_readyStartTime == 1) {
      return "Start!";
    } else {
      return (readyStartTime - 1).toString();
    }
  }

  @override
  void initState() {
    super.initState();
    remaining.shuffle();
    _initialReadyStartTime = _readyStartTime + 2;
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Whack Attack!",
            home: Scaffold(
              appBar: AppBar(
                title: Text(txt,
                    style: const TextStyle(
                        fontSize: 30, fontFamily: 'KenneyBlocks')),
                centerTitle: true,
                backgroundColor: btnColor,
              ),
              backgroundColor: bgColor,
              body: Stack(children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text(
                            "Time Left: ${_countdownTime.toStringAsFixed(1)}s",
                            style: const TextStyle(
                                fontSize: 50,
                                fontFamily: "KenneyPixel",
                                color: Colors.brown),
                          ),
                        ]),
                      ),
                      Builder(builder: (BuildContext context) {
                        return Center(
                            child: SizedBox(
                          height: min(MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width),
                          width: min(MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width),
                          child: GridView.count(
                            crossAxisCount: gdNum,
                            children: List.generate(gdNum * gdNum, (index) {
                              return Material(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (index == remaining[0]) {
                                          score++;
                                          moleCondition[index] = 2;
                                          remaining.removeAt(0);
                                          if (remaining.isNotEmpty == true) {
                                            moleCondition[remaining[0]] = 1;
                                          } else {
                                            btnNext();
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        image: DecorationImage(
                                          image: img[moleCondition[index]],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                              );
                            }),
                          ),
                        ));
                      })
                    ],
                  ),
                ),
                if (_inactive && (_countdownTime == 0 || remaining.isEmpty))
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: const ModalBarrier(
                      dismissible: false,
                      color: bgColor,
                    ),
                  ),
                if (_inactive && !((_countdownTime == 0 || remaining.isEmpty)))
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: const ModalBarrier(
                      dismissible: false,
                      color: bgColor,
                    ),
                  ),
                if (_inactive && _startTimerCountdown)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          format(_readyStartTime),
                          style: const TextStyle(
                              fontSize: 100,
                              fontFamily: "KenneyPixel",
                              color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                if (_inactive && !_startTimerCountdown)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: const Text(
                            "RESULT",
                            style: TextStyle(
                                fontSize: 60,
                                color: Colors.brown,
                                fontFamily: "KenneyMini"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Level:',
                                          style: TextStyle(
                                            fontFamily: "KenneyHigh",
                                            fontSize: 30,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$lvl',
                                          style: TextStyle(
                                            fontSize: 100,
                                            fontFamily: "KenneyPixel",
                                            color:
                                                Color.fromARGB(255, 90, 159, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Score:',
                                          style: TextStyle(
                                            fontFamily: "KenneyHigh",
                                            fontSize: 30,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$total_score',
                                          style: const TextStyle(
                                            fontSize: 100,
                                            fontFamily: "KenneyPixel",
                                            color: Color.fromARGB(
                                                255, 255, 140, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (lvl < 5)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4.6,
                                child: ElevatedButton(
                                    onPressed: () {
                                      gameStopped();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              btnColor),
                                    ),
                                    child: const Center(
                                        child: Text(
                                            style: TextStyle(
                                                fontFamily: 'KenneyBlocks',
                                                fontSize: 15),
                                            'Next'))),
                              )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.6,
                          child: ElevatedButton(
                              onPressed: () {
                                enterScore = true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LeaderboardInterface()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(btnColor),
                              ),
                              child: const Center(
                                  child: Text(
                                      style: TextStyle(
                                          fontFamily: 'KenneyBlocks',
                                          fontSize: 15),
                                      'Exit'))),
                        ),
                      ],
                    ),
                  ),
              ]),
            )),
        onWillPop: () async {
          timer.cancel();
          startTimer.cancel();
          return true;
        });
  }

  void btnNext() {
    timer.cancel();
    total_score += score;
    score = 0;

    _inactive = true;
    _startTimerCountdown = false;
    txt = "";
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_countdownTime <= 0) {
          btnNext();
        } else {
          _countdownTime = max(_countdownTime - 0.1, 0);
        }
      });
    });
  }

  void _startCountdown() {
    _readyStartTime += 2;
    setState(() {
      _inactive = true;
      _startTimerCountdown = true; //manually set on end of btnNext snippet
    });

    startTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _readyStartTime--;
      });

      if (_readyStartTime == 0) {
        timer.cancel();
        setState(() {
          _inactive = false;
          _startTimerCountdown = false;
          moleCondition[remaining[0]] = 1;
          _startTimer();
        });
      }
    });
  }

  void gameStopped() {
    timer.cancel();

    if (lvl < 5) {
      setState(() {
        lvl++;
        txt = 'LEVEL $lvl';
        gdNum = lvl + 1;
        moleCondition = List.generate(gdNum * gdNum, (index) => 0);
        remaining = List.generate(gdNum * gdNum, (index) => index);
        _inactive = true;
        _readyStartTime = 0;
        _countdownTime = 5.0;

        remaining.shuffle();
        _initialReadyStartTime = _readyStartTime + 2;
        _startCountdown();
      });
    } else {
      total_score += score;
      score = 0;
      enterScore = true;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LeaderboardInterface()),
      );
    }
  }
}

class Play extends StatefulWidget {
  const Play({super.key});
  @override
  _PlayGame createState() => _PlayGame();
}
