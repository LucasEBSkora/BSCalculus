import 'BSCalculus/BSCalculus.dart';

int main () {

  Variable x = Variable('x');
  Variable y = Variable('y');

  bscFunction f = Ctg(x);
  print(f);
  print(f.derivative(x));
  return 0;
}