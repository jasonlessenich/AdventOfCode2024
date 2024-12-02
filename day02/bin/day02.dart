import 'package:aoc/aoc.dart';
import 'package:day02/day02.dart';

void main(List<String> arguments) async {
  AOC(
    day: 2,
    title: 'Red-Nosed Reports',
    sampleInputFile: 'input-sample.txt',
    inputFile: 'input.txt',
  ).run(Day02Challenge());
}
