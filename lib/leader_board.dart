import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibration/vibration.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:mad_individual_assignment/main_activity.dart';

int ranking = 1;

class Leaderboard {
  static const _databaseName = 'leaderboard.db';
  static const _databaseVersion = 1;
  static Database? _database;
  static const table = 'leaderboard';

  Leaderboard._privateConstructor();
  static final Leaderboard instance = Leaderboard._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Leaderboard (
  name TEXT PRIMARY KEY,
  score INTEGER NOT NULL
);
          ''');
  }

  static Future<List<Map<String, dynamic>>> enterAndQuery(
      String name, int score) async {
    // Insert the new record
    await _database!.insert(table, {
      "name": name,
      "score": score,
    });

    // Remove excess records if necessary
    final List<Map<String, dynamic>> results = await _database!.query(
      table,
      orderBy: 'Score DESC',
    );
    if (results.length > 25) {
      final idsToDelete = results
          .sublist(25)
          .map((result) => result["name"] as String)
          .toList();
      await _database!.delete(
        table,
        where: 'name IN (${idsToDelete.map((_) => '?').join(', ')})',
        whereArgs: idsToDelete,
      );
    }

    return results;
  }

  static Future<List<Map<String, dynamic>>> initQuery() async {
    final List<Map<String, dynamic>> updatedResults = await _database!.query(
      table,
      orderBy: 'Score DESC',
      limit: 25,
    );
    return updatedResults;
  }

  static Future<Map<String, int>> getLeaderboardData() async {
    Map<String, int> output = <String, int>{};
    final List<Map<String, dynamic>> updatedResults = await _database!.query(
      table,
      orderBy: 'Score DESC',
      limit: 25,
    );

    int minScore = updatedResults.isNotEmpty ? updatedResults.last['score'] : 0;
    int number = updatedResults.length;
    output["minScore"] = minScore;
    output["number"] = number;
    return output;
  }
}

class LeaderboardInterface extends StatefulWidget {
  const LeaderboardInterface({super.key});

  @override
  _LeaderboardInterfaceState createState() => _LeaderboardInterfaceState();
}

class _LeaderboardInterfaceState extends State<LeaderboardInterface> {
  // ignore: non_constant_identifier_names
  bool name_entered = false;
  final nameController = TextEditingController();
  late Future<List<Map<String, dynamic>>> results;
  late Future<Map<String, int>> leaderboardData;

  void _submitName() {
    final tempName = nameController.text.trim();

    if (tempName.isEmpty) {
      Vibration.vibrate(duration: 500);
      Fluttertoast.showToast(
        msg: 'Please enter valid characters!',
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      name_entered = true;
      name = tempName;
      setState(() {
        results = Leaderboard.enterAndQuery(name!, total_score);
      });
    }
  }

  @override
  void initState() {
    name = null;
    super.initState();
    results = Leaderboard.initQuery();
    leaderboardData = Leaderboard.getLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          total_score = 0;
          Navigator.of(context).popUntil((route) => route.isFirst);
          return true;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Whack Attack!',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Leaderboard',
                  style: TextStyle(fontSize: 30, fontFamily: 'KenneyBlocks')),
              centerTitle: true,
              backgroundColor: btnColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  total_score = 0;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  color: bgColor,
                  child: Center(
                      child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 60,
                                fontWeight: FontWeight.w500,
                                color: Colors.brown,
                                fontFamily: "KenneyPixel"),
                            textAlign: TextAlign.center,
                            "SCORE TABLE",
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: results,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                final results = snapshot.data;
                                if (results.length == 0) {
                                  return const Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "\n\nLeaderboard is Empty !!!",
                                      style: TextStyle(
                                          fontFamily: "KenneyMini",
                                          fontSize: 15),
                                    ),
                                  );
                                }
                                ranking = 1;
                                final tableRows = List<TableRow>.generate(
                                    min(results.length, 25),
                                    (int index) => TableRow(
                                          decoration: BoxDecoration(
                                            color:
                                                results[index]['name'] == name
                                                    ? Color.fromARGB(
                                                        255, 246, 239, 102)
                                                    : bgColor,
                                          ),
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                      (ranking++).toString())),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                      results[index]['name'])),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(results[index]
                                                          ['score']
                                                      .toString())),
                                            ),
                                          ],
                                        ));
                                return Column(children: <Widget>[
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1.5),
                                      1: FlexColumnWidth(3.0),
                                      2: FlexColumnWidth(1.5),
                                    },
                                    border: TableBorder.all(),
                                    children: [
                                      const TableRow(
                                        decoration: BoxDecoration(
                                          color: btnColor,
                                        ),
                                        children: <Widget>[
                                          TableCell(
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Ranking',
                                                  style: TextStyle(
                                                      fontFamily: "KenneyMini",
                                                      color: Colors.white),
                                                )),
                                          ),
                                          TableCell(
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontFamily: "KenneyMini",
                                                      color: Colors.white),
                                                )),
                                          ),
                                          TableCell(
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Score',
                                                  style: TextStyle(
                                                      fontFamily: "KenneyMini",
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ],
                                      ),
                                      ...tableRows,
                                    ],
                                  )
                                ]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
                if (enterScore)
                  FutureBuilder<Map<String, int>>(
                    future: leaderboardData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data!["minScore"]! <= total_score ||
                              snapshot.data!["number"]! < 25) &&
                          !name_entered) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height,
                          child: ModalBarrier(
                            dismissible: false,
                            color: bgColor,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                if (enterScore)
                  FutureBuilder<Map<String, int>>(
                    future: leaderboardData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data!["minScore"]! <= total_score ||
                              snapshot.data!["number"]! < 25) &&
                          !name_entered) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.brown,
                                    fontFamily: "KenneyMini",
                                  ),
                                  textAlign: TextAlign.center,
                                  "CONGRATULATIONS ! ^^",
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                      fontFamily: "KenneyPixel"),
                                  textAlign: TextAlign.center,
                                  "\nYou have successfully secured a spot in the \n\nTOP 25 of our leaderboard!:\n",
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    2, //adjust width
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: nameController,
                                  // ignore: prefer_const_constructors
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 244, 227, 227),
                                    hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 25,
                                        fontFamily: 'KenneyPixel'),
                                  ),
                                  onSubmitted: (_) => _submitName(),
                                )),
                          ],
                        ));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              ],
            ),
          ),
        ));
  }
}
