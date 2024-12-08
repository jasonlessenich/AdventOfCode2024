import 'dart:async';
import 'dart:io';

import 'package:aoc/aoc.dart';

enum Tile {
  empty('.'),
  obstacle('#'),
  northGuard('^'),
  eastGuard('>'),
  southGuard('v'),
  westGuard('<')
  ;

  final String symbol;

  const Tile(this.symbol);
}

enum Direction {
  north,
  east,
  south,
  west,
  ;

  Direction rotate() {
    return switch (this) {
      Direction.north => Direction.east,
      Direction.east => Direction.south,
      Direction.south => Direction.west,
      Direction.west => Direction.north,
    };
  }

  static Direction getDirectionByGuard(Tile guard) {
    return switch (guard) {
      Tile.northGuard => Direction.north,
      Tile.eastGuard => Direction.east,
      Tile.southGuard => Direction.south,
      Tile.westGuard => Direction.west,
      _ => throw StateError('Not a guard: $guard'),
    };
  }
}

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  Point move(Direction direction) {
    return switch (direction) {
      Direction.north => Point(x, y - 1),
      Direction.east => Point(x + 1, y),
      Direction.south => Point(x, y + 1),
      Direction.west => Point(x - 1, y),
    };
  }

  @override
  String toString() {
    return '($x, $y)';
  }

  @override
  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}

class GuardMap {
  final List<List<Tile>> _map;

  const GuardMap(this._map);

  factory GuardMap.fromInput(List<String> inputLines) {
    final map = inputLines.map((line) => line.split('').map((char) {
      for (final tile in Tile.values) {
        if (tile.symbol == char) {
          return tile;
        }
      }
      throw StateError('Unknown tile: $char');
    }).toList()).toList();

    return GuardMap(map);
  }

  bool checkBounds(Point p) {
    if (p.y < 0 || p.y >= _map.length) {
      return false;
    }
    if (p.x < 0 || p.x >= _map[p.y].length) {
      return false;
    }
    return true;
  }

  Tile? getTileAtPoint(Point p) {
    if (!checkBounds(p)) {
      return null;
    }
    return _map[p.y][p.x];
  }

  (Point, Direction) getGuardPosition() {
    for (int y = 0; y < _map.length; y++) {
      for (int x = 0; x < _map[y].length; x++) {
        final Tile? tile = getTileAtPoint(Point(x, y));

        if ([Tile.northGuard, Tile.eastGuard, Tile.southGuard, Tile.westGuard].contains(tile)) {
          return (Point(x, y), Direction.getDirectionByGuard(tile!));
        }
      }
    }
    throw StateError('No guard found!');
  }
}

int calculateSteps(GuardMap map) {
  int steps = 0;
  (Point?, Direction) lastPos = map.getGuardPosition();
  List<(Point, Direction)> visited = [(lastPos.$1!, lastPos.$2)];
  while (map.checkBounds(lastPos.$1!)) {
    final nextPos = lastPos.$1!.move(lastPos.$2);

    // rotate 90 degrees when encountering an obstacle
    if (map.getTileAtPoint(nextPos) == Tile.obstacle) {
      final Direction newDir = lastPos.$2.rotate();
      lastPos = (lastPos.$1!.move(newDir), newDir);
    } else {
      lastPos = (lastPos.$1!.move(lastPos.$2), lastPos.$2);
    }

    // count steps (only if we haven't visited this point before)
    if (!visited.any((e) => e.$1 == lastPos.$1)) {
      steps++;
      visited.add((lastPos.$1!, lastPos.$2));
    }
  }
  return steps;
}

class Day06Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final GuardMap map = GuardMap.fromInput(inputLines);
    return calculateSteps(map);
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}