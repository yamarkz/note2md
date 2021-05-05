import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

AnsiPen _blue = AnsiPen()..blue();
AnsiPen _green = AnsiPen()..green();
AnsiPen _red = AnsiPen()..red();

void printInfo(String message) => stdout.writeln(_blue(message));

void printSuccess(String message) => stdout.writeln(_green(message));

void printError(String message) => stdout.writeln(_red(message));

void printSuccessAndExit(String message) {
  printSuccess(message);
  exit(0);
}

void printErrorAndExit(String message) {
  printError(message);
  exit(1);
}
