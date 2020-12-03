import 'dart:collection' show HashMap;
import 'dart:math' as math;

import '../number.dart';
import '../single_operand_function.dart';
import '../variable.dart';
import '../functions.dart';
import '../function.dart';
import '../trig/ctg.dart';

BSFunction arcctg(BSFunction operand) {
  return (operand is Ctg) ? operand.operand : ArcCtg._(operand);
}

class ArcCtg extends singleOperandFunction {
  const ArcCtg._(BSFunction operand, [Set<Variable> params])
      : super(operand, params);

  @override
  BSFunction evaluate(HashMap<String, BSFunction> p) {
    final op = operand.evaluate(p);
    if (op is Number) {
      //put simplifications here
    }
    return arcctg(op);
  }

  @override
  BSFunction get approx {
    final op = operand.approx;
    if (op is Number) {
      return n(math.atan(1 / op.value));
    } else {
      return arcctg(op);
    }
  }

  @override
  BSFunction derivativeInternal(Variable v) =>
      (-operand.derivativeInternal(v) / (n(1) + (operand ^ n(2))));

  @override
  BSFunction copy([Set<Variable> params]) => ArcCtg._(operand, params);
}