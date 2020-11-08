import 'dart:collection' show HashMap;
import 'dart:math' as math;

import '../abs.dart';
import '../number.dart';
import '../root.dart';
import '../variable.dart';
import '../βs_function.dart';
import '../hyperbolic/csch.dart';
import '../single_operand_function.dart';

BSFunction arcsch(BSFunction operand) {
  return (operand is CscH) ? operand.operand : ArCscH._(operand);
}

class ArCscH extends singleOperandFunction {
  ArCscH._(BSFunction operand, [Set<Variable> params]) : super(operand, params);

  @override
  BSFunction evaluate(HashMap<String, BSFunction> p) {
    final op = operand.evaluate(p);
    if (op is Number) {
      //put simplifications here
    }
    return arcsch(op);
  }

  @override
  BSFunction get approx {
    final op = operand.approx;
    if (op is Number) {
      return n(_arcsch(op.value));
    } else {
      return arcsch(op);
    }
  }

  @override
  BSFunction derivativeInternal(Variable v) => (-operand.derivativeInternal(v) /
      (abs(operand) * root((operand ^ n(2)) + n(1))));

  @override
  BSFunction copy([Set<Variable> params]) => ArCscH._(operand, params);
}

double _arcsch(double v) => math.log(math.sqrt(1 + math.pow(v, 2)) / v);
