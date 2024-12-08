import 'dart:async';

import 'package:aoc/aoc.dart';

enum Tile {
  empty('.'),
  obstacle('#'),
  visited('X'),
  northGuard('^'),
  eastGuard('>'),
  southGuard('v'),
  westGuard('<')
  ;

  final String symbol;

  const Tile(this.symbol);

  static Tile getGuardByDirection(Direction direction) {
    return switch (direction) {
      Direction.north => Tile.northGuard,
      Direction.east => Tile.eastGuard,
      Direction.south => Tile.southGuard,
      Direction.west => Tile.westGuard,
    };
  }
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

  @override
  String toString() {
    return '($x, $y)';
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

  Tile? getTileAtPoint(Point p) {
    if (p.y < 0 || p.y >= _map.length) {
      return null;
    }
    if (p.x < 0 || p.x >= _map[p.y].length) {
      return null;
    }
    return _map[p.y][p.x];
  }

  Point? setTileAtPoint(Point p, Tile tile) {
    if (getTileAtPoint(p) == null) {
      return null;
    }
    _map[p.y][p.x] = tile;
    return p;
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

  (Point, Direction) getNextGuardPosition([Direction? directionOverride]) {
    final (point, direction) = getGuardPosition();

    final Point nextPos = switch (directionOverride ?? direction) {
      Direction.north => Point(point.x, point.y - 1),
      Direction.east => Point(point.x + 1, point.y),
      Direction.south => Point(point.x, point.y + 1),
      Direction.west => Point(point.x - 1, point.y),
    };

    return getTileAtPoint(nextPos) == Tile.obstacle ? getNextGuardPosition(direction.rotate()) : (nextPos, directionOverride ?? direction);
  }

  Point? setNextGuardPosition() {
    final (point, _) = getGuardPosition();
    final (nextPoint, nextDirection) = getNextGuardPosition();

    setTileAtPoint(point, Tile.visited);
    return setTileAtPoint(nextPoint, Tile.getGuardByDirection(nextDirection));
  }

  int countTiles(Tile tile) {
    int acc = 0;

    for (List<Tile> y in _map) {
      for (Tile x in y) {
        if (x == tile) {
          acc++;
        }
      }
    }

    return acc;
  }
}

int calculateGuardPath(GuardMap map) {
  Point? lastGuardPos = map.getGuardPosition().$1;
  while (lastGuardPos != null) {
    lastGuardPos = map.setNextGuardPosition();
  }

  for (List<Tile> y in map._map) {
    print(y.map((t) => t.symbol).join());
  }

  return map.countTiles(Tile.visited);
}

class Day06Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final GuardMap map = GuardMap.fromInput(inputLines);
    return calculateGuardPath(map);
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}