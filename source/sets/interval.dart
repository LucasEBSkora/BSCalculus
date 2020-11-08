import 'empty_set.dart';
import 'roster_set.dart';
import 'set_union.dart';
import 'βs_set.dart';
import '../βs_function/number.dart';
import '../βs_function/βs_function.dart';

BSSet interval(BSFunction a, BSFunction b,
    {bool leftClosed = true, bool rightClosed = true}) {
  if (!BSFunction.extractFromNegative<Number>(a).second ||
      !BSFunction.extractFromNegative<Number>(b).second) {
    throw BetascriptFunctionError("sets can only be defined in numbers");
  }
  if (a == b) {
    return (leftClosed && rightClosed) ? rosterSet([a]) : emptySet;
  } else if (a > b) {
    return emptySet;
  } else {
    return Interval(a, b, leftClosed, rightClosed);
  }
}

//a class that represents an interval in R
class Interval extends BSSet {
  final bool leftClosed;
  final bool rightClosed;
  final BSFunction a;
  final BSFunction b;

  const Interval(this.a, this.b, this.leftClosed, this.rightClosed);

  const Interval.closed(this.a, this.b)
      : this.leftClosed = true,
        this.rightClosed = true;
  const Interval.open(this.a, this.b)
      : this.leftClosed = false,
        this.rightClosed = false;

  //doesn't need to check if x is number because < will do it anyway
  @override
  bool belongs(BSFunction x) =>
      (a < x && x < b) || (a == x && leftClosed) || (x == b && rightClosed);

  @override
  BSSet complement() => SetUnion([
        Interval(-constants.infinity, a, false, !leftClosed),
        Interval(b, constants.infinity, !rightClosed, false)
      ]);

  @override
  String toString() =>
      "${(leftClosed) ? '[' : '('}$a,$b${(rightClosed) ? ']' : ')'}";
}