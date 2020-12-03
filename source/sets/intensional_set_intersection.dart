import 'set.dart';
import '../function/function.dart';

///shouldn't be created directly: derived from intersections involving Builder sets where finding every solution isn't guaranteed
class IntensionalSetIntersection extends BSSet {
  final BSSet first;
  final BSSet second;

  const IntensionalSetIntersection(this.first, this.second);

  @override
  bool belongs(BSFunction x) => first.belongs(x) && second.belongs(x);

  @override
  BSSet complement() => first.complement().union(second.complement());

  @override
  String toString() => "($first) ∩ ($second)";
}
