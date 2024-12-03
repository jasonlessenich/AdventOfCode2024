import 'dart:async';

import 'package:aoc/aoc.dart';

const mulPattern = r"mul\(\d{1,3},\d{1,3}\)";

int processMul(String mul) {
  final stripped = mul
      .replaceAll('mul', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .trim();
  final split = stripped.split(',');
  return int.parse(split[0]) * int.parse(split[1]);
}

class Day03Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    int acc = 0;
    final regex = RegExp(mulPattern);
    for (String line in inputLines) {
      final matches = regex.allMatches(line);
      for (final match in matches) {
        final mul = match.group(0);
        if (mul == null) continue;
        acc += processMul(mul);
      }
    }
    return acc;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}