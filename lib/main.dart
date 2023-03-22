
import 'package:flutter/material.dart';
import 'package:mad_individual_assignment/main_page.dart';
import 'package:mad_individual_assignment/leader_board.dart';

const Color btnColor = Color.fromARGB(255, 206, 142, 96);
const Color bgColor = Color.fromARGB(255, 246, 236, 203);

bool enterScore = false;
// ignore: non_constant_identifier_names
int total_score = 0, lvl = 1;

String? name; // let the String become nullable

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Leaderboard.instance.database; // load database

  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: HomeInterface()));
}

//apk build location: C:\Users\yichu\Desktop\MAD_Individual_Assignment\mad_individual_assignment\build\app\outputs\apk\debug\app-debug.apk
//flutter clean > flutter build apk --release > build\app\outputs\flutter-apk\app-release.apk 