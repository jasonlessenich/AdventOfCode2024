import 'dart:async';

import 'package:aoc/aoc.dart';

class PageOrderRule {
  final int before;
  final int after;

  const PageOrderRule(this.before, this.after);
}

class PageUpdate {
  final List<int> pages;

  const PageUpdate(this.pages);
  
  int getMiddlePage() {
    return pages[pages.length ~/ 2];
  }
  
  List<int> getPagesNeededBefore(int page, List<PageOrderRule> rules) {
    return rules
        .where((r) => r.after == page)
        .where((r) => pages.contains(r.before))
        .map((r) => r.before).toList();
  }

  bool doesRuleNotProhibit(int page, List<PageOrderRule> rules, List<int> previousNumbers) {
    return previousNumbers.contains(page) ||
      getPagesNeededBefore(page, rules).every((i) => previousNumbers.contains(i));
  }

  bool isValid(List<PageOrderRule> rules) {
    final List<int> previousNumbers = [];
    for (int page in pages) {
      if (!doesRuleNotProhibit(page, rules, previousNumbers)) {
        return false;
      }
      previousNumbers.add(page);
    }
    return true;
  }
}

(List<PageOrderRule>, List<PageUpdate>) parseInput(List<String> inputLines) {
  final List<PageOrderRule> rules = [];
  final List<PageUpdate> updates = [];

  for (String line in inputLines) {
    if (line.isEmpty) continue;

    if (line.contains('|')) {
      final split = line.split('|').map(int.parse).toList();
      rules.add(PageOrderRule(split[0], split[1]));
    } else if (line.contains(',')) {
      final pages = line.split(',').map(int.parse).toList();
      updates.add(PageUpdate(pages));
    }
  }

  return (rules, updates);
}

class Day05Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final (rules, updates) = parseInput(inputLines);
    int acc = 0;
    for (PageUpdate u in updates) {
      if (u.isValid(rules)) acc += u.getMiddlePage();
    }
    return acc;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}