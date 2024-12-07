import 'dart:async';

import 'package:aoc/aoc.dart';

List<List<int>> splitInput(List<String> lines) {
  return lines
      .map((l) => l.split(' ').map((s) => int.parse(s)).toList())
      .toList();
}

/// Checks whether the level is valid
bool isValidLevel(List<int> level) {
  bool? isDecreasing;
  int previousNum = level[0];
  for (final i in level.skip(1)) {
    // two times the same number is also invalid
    if (i == previousNum) {
      return false;
    }
    isDecreasing ??= i < previousNum;
    // check if numbers are still decreasing
    if ((isDecreasing && previousNum < i) ||
        (!isDecreasing && previousNum > i)) {
      return false;
    }
    // check diff between numbers
    final diff = (previousNum - i).abs();
    if (diff <= 0 || diff > 3) {
      return false;
    }
    previousNum = i;
  }
  return true;
}

/// Checks whether the level is safe, respecting the "Problem Dampener"
bool isLevelSafe(List<int> level) {
  if (isValidLevel(level)) {
    return true;
  }
  for (final (index, _) in level.indexed) {
    // remove index to check if we can make this level work without this
    final shorted = List.of(level)..removeAt(index);
    if (isValidLevel(shorted)) {
      return true;
    }
  }

  return false;
}

class Day02Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final levels = splitInput(inputLines);
    int acc = 0;
    for (List<int> level in levels) {
      if (isValidLevel(level)) {
        acc++;
      }
    }
    return acc;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    final levels = splitInput(inputLines);
    int acc = 0;
    for (List<int> level in levels) {
      if (isLevelSafe(level)) {
        acc++;
      }
    }
    return acc;
  }
}
