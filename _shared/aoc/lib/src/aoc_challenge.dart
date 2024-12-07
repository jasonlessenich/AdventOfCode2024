import 'dart:async';

abstract interface class AOCChallenge<T> {
  FutureOr<T> part1(String input, List<String> inputLines);
  FutureOr<T> part2(String input, List<String> inputLines);
}
