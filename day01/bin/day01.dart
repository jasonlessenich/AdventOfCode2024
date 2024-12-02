import 'package:aoc/aoc.dart';
import 'package:day01/day01.dart';

void main(List<String> arguments) async {
  AOC(
    day: 1,
    title: 'Historian Hysteria',
    sampleInputFile: 'input-sample.txt',
    inputFile: 'input.txt',
  ).run(Day01Challenge());
}
