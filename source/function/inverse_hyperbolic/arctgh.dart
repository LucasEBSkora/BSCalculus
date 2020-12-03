import 'dart:collection' show HashMap;
import 'dart:math' as math;

import '../number.dart';
import '../single_operand_function.dart';
import '../variable.dart';
import '../functions.dart';
import '../function.dart';
import '../hyperbolic/ctgh.dart';

BSFunction arctgh(BSFunction operand) {
  return (operand is CtgH) ? operand.operand : ArCtgH._(operand);
}

class ArCtgH extends singleOperandFunction {
  const ArCtgH._(BSFunction operand, [Set<Variable> params])
      : super(operand, params);

  @override
  BSFunction evaluate(HashMap<String, BSFunction> p) {
    final op = operand.evaluate(p);
    if (op is Number) {
      //put simplifications here
    }
    return arctgh(op);
  }

  @override
  BSFunction get approx {
    final op = operand.approx;
    if (op is Number) {
      return n(_arctgh(op.value));
    } else {
      return arctgh(op);
    }
  }

  @override
  BSFunction derivativeInternal(Variable v) =>
      (operand.derivativeInternal(v) / (n(1) - operand ^ n(2)));

  @override
  BSFunction copy([Set<Variable> params]) => ArCtgH._(operand, params);
}

double _arctgh(double v) => 0.5 * math.log((v + 1) / (v - 1));