import 'dart:async';
import 'dart:io';

import 'package:aoc/aoc.dart';

class Vector {
  final int x;
  final int y;

  const Vector(this.x, this.y);

  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);
  bool operator ==(Object other) => other is Vector && other.x == x && other.y == y;

  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vector($x, $y)';
}

class AntennaMap {
  final List<List<int>> matrix;

  const AntennaMap(this.matrix);

  factory AntennaMap.fromInput(List<String> lines) {
    final matrix = lines.map((line) => line.codeUnits).toList();
    return AntennaMap(matrix);
  }

  Map<int, List<Vector>> getGroupedAntennas() {
    final Map<int, List<Vector>> antennas = {};

    for (int y = 0; y < matrix.length; y++) {
      for (int x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x] != '.'.codeUnitAt(0)) {
          antennas[matrix[y][x]] = (antennas[matrix[y][x]]?..add(Vector(x, y))) ?? [Vector(x, y)];
        }
      }
    }

    return antennas;
  }

  bool isInBounds(Vector v) => v.x >= 0 && v.x < matrix[0].length && v.y >= 0 && v.y < matrix.length;

  Set<Vector> calculateAntiNodes(List<Vector> antennas, {bool respectEffectsOfResonantHarmonics = false}) {
    final List<Vector> nodes = [];
    int antennaIndex = 0;

    // compare each antenna with each other
    for (int i = 0; i < antennas.length; i++) {
      for (int j = 0; j < antennas.length; j++) {
        if (j == antennaIndex) continue;
        final Vector end = antennas[j];
        final Vector diff = (end - antennas[antennaIndex]);
        if (respectEffectsOfResonantHarmonics) {
          // add current end node
          nodes.add(end);
          // add all multiples of diff until out of bounds
          Vector pos = end + diff;
          while (isInBounds(pos)) {
            nodes.add(pos);
            pos = pos + diff;
          }
        } else {
          nodes.add(end + diff);
        }
      }
      antennaIndex++;
    }
    return nodes.where(isInBounds).toSet();
  }
}

class Day08Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final map = AntennaMap.fromInput(inputLines);
    return map.getGroupedAntennas().entries
        .map((e) => map.calculateAntiNodes(e.value))
        .expand((e) => e)
        .toSet()
        .length;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    final map = AntennaMap.fromInput(inputLines);
    return map.getGroupedAntennas().entries
        .map((e) => map.calculateAntiNodes(e.value, respectEffectsOfResonantHarmonics: true))
        .expand((e) => e)
        .toSet()
        .length;
  }
}