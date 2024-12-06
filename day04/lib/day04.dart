import 'dart:async';

import 'package:aoc/aoc.dart';

enum Direction {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest,
}

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  Point getAdjacent(Direction dir) {
    return switch(dir) {
      Direction.north => Point(x, y - 1),
      Direction.northEast => Point(x + 1, y - 1),
      Direction.east => Point(x + 1, y),
      Direction.southEast => Point(x + 1, y + 1),
      Direction.south => Point(x, y + 1),
      Direction.southWest => Point(x - 1, y + 1),
      Direction.west => Point(x - 1, y),
      Direction.northWest => Point(x - 1, y - 1),
    };
  }
}

class WordSearch {
  final List<List<int>> matrix;

  const WordSearch(this.matrix);

  factory WordSearch.fromInput(List<String> input) {
    final List<List<int>> matrix = [];
    for (String line in input) {
      matrix.add(line.codeUnits);
    }
    return WordSearch(matrix);
  }

  /// Gets the letter at the given point
  int? getLetterAtPoint(Point p) {
    if (p.y < 0 || p.y >= matrix.length) {
      return null;
    }
    if (p.x < 0 || p.x >= matrix[p.y].length) {
      return null;
    }
    return matrix[p.y][p.x];
  }

  /// Gets the first surrounding letter and returns the point and direction
  /// If there are multiple surrounding letters, only the first one is returned
  (Point, Direction)? getSurroundingLetter(Point p, int letter, {List<Direction>? allowedDirections}) {
    for (Direction dir in allowedDirections ?? Direction.values) {
      final Point adjacent = p.getAdjacent(dir);
      if (getLetterAtPoint(adjacent) == letter) {
        return (adjacent, dir);
      }
    }
    return null;
  }

  /// Gets all surrounding letters and returns their point and direction
  List<(Point, Direction)> getAllSurroundingLetters(Point p, int letter) {
    return Direction.values
        .map((dir) => getSurroundingLetter(p, letter, allowedDirections: [dir]))
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }

  /// Searches for the given word in the matrix
  List<List<Point>> searchWords(String word) {
    if (word.isEmpty || word.length <= 2) {
      throw ArgumentError('Word may not be empty or shorter than 2 characters!');
    }
    final List<List<Point>> result = [];
    final List<Point> startingLetters = searchLetters(word.codeUnits.first);

    for (Point startLetter in startingLetters) {
      final List<(Point, Direction)> allSurroundingLetters = getAllSurroundingLetters(startLetter, word.codeUnits[1]);

      for (final (p, dir) in allSurroundingLetters) {
        List<Point> matches = [startLetter, p];
        // go through all letters one by one and check if the last match is surrounded by one
        for (int letter in word.codeUnits.skip(2)) {
          final (Point, Direction)? nextSurrounding = getSurroundingLetter(matches.last, letter, allowedDirections: [dir]);
          if (nextSurrounding == null) {
            // no surrounding letter found, so this is not a match
            matches = [];
            break;
          }
          matches.add(nextSurrounding.$1);
        }

        if (matches.isNotEmpty) {
          result.add(matches);
        }
      }
    }
    return result;
  }

  List<Point> searchLetters(int letter) {
    final List<Point> result = [];
    for (int y = 0; y < matrix.length; y++) {
      for (int x = 0; x < matrix[y].length; x++) {
        final Point p = Point(x, y);
        if (getLetterAtPoint(p) == letter) {
          result.add(p);
        }
      }
    }
    return result;
  }
}

class Day04Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final result = WordSearch.fromInput(inputLines).searchWords('XMAS');
    return result.length;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}
