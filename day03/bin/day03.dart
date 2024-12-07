import 'package:aoc/aoc.dart';
import 'package:day03/day03.dart';

void main(List<String> arguments) async {
  AOC(
          day: 3,
          title: 'Mull It Over',
          sampleInputFile: 'input-sample.txt',
          inputFile: 'input.txt',
          part2SampleInputFile: 'input-02-sample.txt')
      .run(Day03Challenge());
}
