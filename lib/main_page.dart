import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mad_individual_assignment/main_activity.dart';
import 'package:mad_individual_assignment/game_activity.dart';
import 'package:mad_individual_assignment/leader_board.dart';

class HomeInterface extends StatefulWidget {
  const HomeInterface({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeInterfaceState createState() => _HomeInterfaceState();
}

class _HomeInterfaceState extends State<HomeInterface> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whack Attack!',
        home: Scaffold(
            backgroundColor: bgColor,
            body: Center(
                child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Column(
                    children: [
                      Image.asset(
                        'assets/images/game_title.png',
                        width: max(MediaQuery.of(context).size.width / 2.5,
                            MediaQuery.of(context).size.height / 2.5),
                        height: max(MediaQuery.of(context).size.width / 2.5,
                            MediaQuery.of(context).size.height / 2.5),
                      ),
                      Image.asset(
                        'assets/images/mole_home.png',
                        width: max(MediaQuery.of(context).size.width / 6,
                            MediaQuery.of(context).size.height / 6),
                        height: max(MediaQuery.of(context).size.width / 6,
                            MediaQuery.of(context).size.height / 6),
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: ElevatedButton(
                              onPressed: () {
                                total_score = 0;
                                lvl = 1;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Play(key: UniqueKey()),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(btnColor),
                              ),
                              child: const Center(
                                child: Text(
                                  style: TextStyle(
                                      fontFamily: 'KenneyBlocks', fontSize: 15),
                                  'Start Game',
                                ),
                              ),
                            ))),
                  ),
                  Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: ElevatedButton(
                              onPressed: () {
                                enterScore = false;
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
                                      'Leaderboards'))))),
                ],
              ),
            ))));
  }
}
