import 'dart:async';

import 'package:aoc/aoc.dart';

(List<int>, List<int>) parseToLists(List<String> input) {
  final List<int> left = [];
  final List<int> right = [];

  for (String line in input) {
    final List<String> split = line.split("   ");
    left.add(int.parse(split[0].trim()));
    right.add(int.parse(split[1].trim()));
  }

  return (left, right);
}

int calculateSimilarityScore(List<int> left, List<int> right) {
  int acc = 0;
  for (int i in left) {
    acc += i * right.where((j) => j == i).length;
  }
  return acc;
}

class Day01Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final (left, right) = parseToLists(inputLines);
    final List<int> sortedLeft = List.of(left)..sort();
    final List<int> sortedRight = List.of(right)..sort();
    int sum = 0;
    for (final (index, _) in inputLines.indexed) {
      sum += (sortedLeft[index] - sortedRight[index]).abs();
    }
    return sum;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    final (left, right) = parseToLists(inputLines);
    return calculateSimilarityScore(left, right);
  }
}
