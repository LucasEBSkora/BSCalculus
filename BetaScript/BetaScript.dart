import 'dart:io';

import 'ASTPrinter.dart';
import 'BSParser.dart';
import 'BSScanner.dart';
import 'Expr.dart';
import 'Token.dart';

class BetaScript {
  static bool hadError = false;

  static void runFile(String path) {
    File file = File(path);
    String fileContents = file.readAsStringSync();
    _run(fileContents);

    if (hadError) exit(1);
  }

  static void runPrompt() {
    
    while (true) {
      stdout.write("> ");
      _run(stdin.readLineSync());
      hadError = false;
    }
  }

  static void _run(String source) {
    BSScanner scanner = new BSScanner(source);
    List<Token> tokens = scanner.scanTokens();
    BSParser parser = new BSParser(tokens);
    Expr expression = parser.parse();
    print(ASTPrinter().print(expression));
  }  

  static void error(dynamic value, String message) {
    if (value is int) _errorAtLine(value, message);
    else if (value is Token) _errorAtToken(value, message);
    else _report(-1, "at unknown location: '" + value.toString() + "'", message);
  }

  static void _errorAtLine(int line, String message) {
    _report(line, "", message);
  }

  static void _errorAtToken(Token token, String message) {
    if (token.type == TokenType.EOF) _report(token.line, " at end", message);
    else _report(token.line, " at '" + token.lexeme + "'", message);
  }

  static void _report(int line, String where, String message) {
    print("[line " + line.toString() + "] Error" + where + ": " + message);
    hadError = true;
  }

}