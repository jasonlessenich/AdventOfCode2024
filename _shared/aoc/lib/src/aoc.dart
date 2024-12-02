import 'package:aoc/src/aoc_challenge.dart';
import 'dart:io';

class AOC {
  final int day;
  final String title;

  final String sampleInputFile;
  final String inputFile;

  const AOC({
    required this.day,
    required this.title,
    required this.sampleInputFile,
    required this.inputFile,
  });

  Future<void> run<T>(AOCChallenge<T> challenge) async {
    print('--- Day $day: $title ---');
    final sampleInput = await _readInput(sampleInputFile);

    final part1Input = await _readInput(inputFile);
    _runTask('part1 (sample)', sampleInputFile, () => challenge.part1(sampleInput.$1, sampleInput.$2));
    _runTask('part1', inputFile, () => challenge.part1(part1Input.$1, part1Input.$2));

    final part2Input = await _readInput(inputFile);
    _runTask('part2 (sample)', sampleInputFile, () => challenge.part2(sampleInput.$1, sampleInput.$2));
    _runTask('part2', inputFile, () => challenge.part2(part2Input.$1, part2Input.$2));
  }

  Future<(String, List<String>)> _readInput(String fileName) async {
    final file = File(fileName);
    if (!(await file.exists())) {
      throw Exception('File not found: $fileName');
    }

    final input = await file.readAsString();
    final inputLines = await file.readAsLines();
    return (input, inputLines);
  }

  void _runTask<T>(String name, String file, T Function() task) {
    print('Running $name with input: $file');
    final Stopwatch stopwatch = Stopwatch()..start();
    late T result;
    try {
      result = task();
    } on UnimplementedError {
      print('$name = Not implemented\n');
      return;
    } finally {
      stopwatch.stop();
    }
    print('$name = ${result.toString()} (${stopwatch.elapsedMilliseconds}ms)\n');
  }
}
