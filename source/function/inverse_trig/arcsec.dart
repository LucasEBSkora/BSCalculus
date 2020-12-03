import 'dart:collection' show HashMap;
import 'dart:math' as math;

import '../abs.dart';
import '../number.dart';
import '../root.dart';
import '../single_operand_function.dart';
import '../variable.dart';
import '../functions.dart';
import '../function.dart';
import '../trig/sec.dart';

BSFunction arcsec(BSFunction operand) {
  return (operand is Sec) ? operand.operand : ArcSec._(operand);
}

class ArcSec extends singleOperandFunction {
  const ArcSec._(BSFunction operand, [Set<Variable> params])
      : super(operand, params);

  @override
  BSFunction evaluate(HashMap<String, BSFunction> p) {
    final op = operand.evaluate(p);
    if (op is Number) {
      //put simplifications here
    }
    return arcsec(op);
  }

  @override
  BSFunction get approx {
    final op = operand.approx;
    if (op is Number) {
      return n(math.acos(1 / op.value));
    } else {
      return arcsec(op);
    }
  }

  @override
  BSFunction derivativeInternal(Variable v) => (operand.derivativeInternal(v) /
      (abs(operand) * root((operand ^ n(2)) - n(1))));

  @override
  BSFunction copy([Set<Variable> params]) => ArcSec._(operand, params);
}