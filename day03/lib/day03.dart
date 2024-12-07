import 'dart:async';

import 'package:aoc/aoc.dart';

const mulPattern = r"mul\(\d{1,3},\d{1,3}\)";
const doPattern = r"do\(\)";
const dontPattern = r"don\'t\(\)";

int processMul(String mul) {
  final stripped =
      mul.replaceAll('mul', '').replaceAll('(', '').replaceAll(')', '').trim();
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
    final mulRegex = RegExp(mulPattern);
    final doRegex = RegExp(doPattern);
    final dontRegex = RegExp(dontPattern);

    int acc = 0;
    bool enabled = true;
    for (String line in inputLines) {
      final mulMatches = mulRegex.allMatches(line);
      final doMatches = doRegex.allMatches(line);
      final dontMatches = dontRegex.allMatches(line);

      // simply join all matches together & sort by start
      for (final match in [...mulMatches, ...doMatches, ...dontMatches]
        ..sort((a, b) => a.start.compareTo(b.start))) {
        final m = match.group(0);
        if (m == null) continue;
        // check if is either do or don't
        if (m.contains('do')) {
          enabled = !m.contains('\'');
          continue;
        }
        // only process the mul if it is enabled
        acc += enabled ? processMul(m) : 0;
      }
    }
    return acc;
  }
}
