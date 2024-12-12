import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aoc/aoc.dart';

enum Operator {
  add,
  multiply,
  concatenate
  ;

  int apply(int a, int b) {
    return switch (this) {
      Operator.add => a + b,
      Operator.multiply => a * b,
      Operator.concatenate => int.parse('$a$b')
    };
  }
}

class Equation {
  final int result;
  final List<int> values;

  Equation(this.result, this.values);

  int get operatorPositions => values.length -1;

  bool isValid(List<Operator> operators) {
    if (operators.length != operatorPositions) {
      throw ArgumentError('Equation $values needs $operatorPositions operators, got ${operators.length}');
    }

    int opIndex = 0;
    int acc = values.first;
    for (int i in values.skip(1)) {
      acc = operators[opIndex++].apply(acc, i);
    }
    return acc == result;
  }
}

List<List<Operator>> getPossibleCombinations(int size, List<Operator> ops) {
  final List<List<Operator>> result = [];
  final num possibleSolutions = pow(ops.length, size);

  for (int i = 0; i < possibleSolutions; i++) {
    final List<Operator> combination = [];
    int j = i;
    for (int k = 0; k < size; k++) {
      combination.add(ops[j % ops.length]);
      j ~/= ops.length;
    }
    result.add(combination);
  }

  return result;
}

List<Equation> parseEquations(List<String> lines) {
  final List<Equation> equations = [];

  for (String line in lines) {
   final List<String> split = line.split(':');
   equations.add(
     Equation(
       int.parse(split[0]),
       split[1].trim().split(' ').map(int.parse).toList()
     )
   );
  }
  return equations;
}

class Day07Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final List<Equation> equations = parseEquations(inputLines);
    return equations
        .where((e) => getPossibleCombinations(e.operatorPositions, [Operator.add, Operator.multiply]).any((c) => e.isValid(c)))
        .map((e) => e.result)
        .fold<int>(0, (a, b) => a + b);
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    final List<Equation> equations = parseEquations(inputLines);
    return equations
        .where((e) => getPossibleCombinations(e.operatorPositions, Operator.values).any((c) => e.isValid(c)))
        .map((e) => e.result)
        .fold<int>(0, (a, b) => a + b);
  }
}