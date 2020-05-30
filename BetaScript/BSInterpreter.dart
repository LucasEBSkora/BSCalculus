import '../BSCalculus/bscFunction.dart';
import 'BSEnvironment.dart';
import 'BetaScript.dart';
import 'Expr.dart';
import 'Stmt.dart';
import 'Token.dart';

class BSInterpreter extends ExprVisitor with StmtVisitor {
  Environment _environment = new Environment();

  void interpret(List<Stmt> statements) {
    try {
      for (Stmt stmt in statements) {
        _execute(stmt);
      }
    } on RuntimeError catch (e) {
      BetaScript.runtimeError(e);
    }
  }

  void _execute(Stmt stmt) => stmt.accept(this);

  String _stringify(dynamic object) {
    if (object == null) return 'nil';

    //Temporary botch - won't be needed when everything is a BSFunction
    if (object is double) {
      String text = object.toString();

      if (text.endsWith(".0")) {
        text = text.substring(0, text.length - 2);
      }

      return text;
    }

    return object.toString();
  }

  @override
  visitBinaryExpr(BinaryExpr e) {

    dynamic leftOperand = _evaluate(e.left);
    dynamic rightOperand = _evaluate(e.right);

    switch (e.op.type) {
      case TokenType.MINUS:
        _checkNumberOperands(e.op, leftOperand, rightOperand);
        return leftOperand - rightOperand;
      case TokenType.SLASH:
        _checkNumberOperands(e.op, leftOperand, rightOperand);
        return leftOperand / rightOperand;
      case TokenType.STAR:
        _checkNumberOperands(e.op, leftOperand, rightOperand);
        return leftOperand * rightOperand;
      case TokenType.PLUS:
        _checkStringOrNumberOperands(e.op, leftOperand, rightOperand);
        return leftOperand + rightOperand;

      case TokenType.GREATER:
        return leftOperand > rightOperand;
      case TokenType.GREATER_EQUAL:
        return leftOperand >= rightOperand;
      case TokenType.LESS:
        return leftOperand < rightOperand;
      case TokenType.LESS_EQUAL:
        return leftOperand <= rightOperand;
      case TokenType.EQUAL_EQUAL:
        return _isEqual(leftOperand, rightOperand);
      default:
    }

    return null;
  }

  @override
  visitGroupingExpr(GroupingExpr e) => _evaluate(e.expression);

  @override
  dynamic visitLiteralExpr(LiteralExpr e) => e.value;

  @override
  visitUnaryExpr(UnaryExpr e) {
    dynamic operand = _evaluate(e.right);

    switch (e.op.type) {
      case TokenType.MINUS:
        _checkNum(e.op, operand);
        return -operand; //Dynamically typed language - if the conversion fails from operand to num fails, it is intended behavior
      //"not" (!) would be here, but i decided to use it for factorials and use the "not" keyword explicitly
      default:
    }

    return null;
  }

  dynamic _evaluate(Expr e) => e.accept(this);

  //null and false are "falsy" everything else is "truthy" (isn't the value 'true' but can be used in logic as if it was)
  static bool _istruthy(dynamic object) =>
      ((object is bool) ? object : (!object == null));

  static _isEqual(dynamic a, dynamic b) {
    if (a == null && b == null) return true; //null is only equal to null
    if (a == null || b == null) return false;

    return a == b;
  }

  static void _checkNum(Token token, dynamic value) {
    if (!(value is bscFunction))
      throw new RuntimeError(
          value, "Operand for " + token.lexeme + " must be a number");
  }

  static void _checkNumberOperands(Token token, dynamic left, dynamic right) {
    if (!(left is bscFunction) || !(right is bscFunction))
      throw new RuntimeError(
          token, "Operands for " + token.lexeme + " must be numbers");
  }

  void _checkStringOrNumberOperands(Token token, dynamic left, dynamic right) {
    try {
      _checkNumberOperands(token, left, right);
    } on RuntimeError {
      if (!(left is String) || !(right is String))
        throw new RuntimeError(token,
            "Operands for " + token.lexeme + " must be numbers or strings");
    }
  }

  @override
  void visitExpressionStmt(ExpressionStmt stmt) =>
      _evaluate(stmt.expression);

  @override
  void visitPrintStmt(PrintStmt stmt) {
    dynamic value = _evaluate(stmt.expression);
    print(_stringify(value));
  }

  @override
  void visitVarStmt(VarStmt s) {
    Object value = null;
    if (s.initializer != null) {
      value = _evaluate(s.initializer);
    }
    _environment.define(s.name.lexeme, value);
  }

  @override
  visitVariableExpr(VariableExpr e) => _environment.get(e.name);

  @override
  visitAssignExpr(AssignExpr e) {
    
    Object value = _evaluate(e);

    _environment.assign(e.name, value);

    return value;
  }


}

class RuntimeError implements Exception {
  final Token token;
  final String message;

  RuntimeError(Token this.token, String this.message);

  @override
  String toString() =>
      "Runtime Error: '" + message + "' at line " + token.line.toString();
}
