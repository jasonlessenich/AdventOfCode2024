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

List<int> getPagesNeededBefore(int page, List<int> pages, List<PageOrderRule> rules) {
  return rules
      .where((r) => r.after == page)
      .where((r) => pages.contains(r.before))
      .map((r) => r.before).toList();
}

bool doesRuleNotProhibit(int page, List<int> pages, List<PageOrderRule> rules, List<int> previousNumbers) {
  return previousNumbers.contains(page) ||
      getPagesNeededBefore(page, pages, rules).every((i) => previousNumbers.contains(i));
}

bool isValid(List<int> pages, List<PageOrderRule> rules) {
  final List<int> previousNumbers = [];
  for (int page in pages) {
    if (!doesRuleNotProhibit(page, pages, rules, previousNumbers)) {
      return false;
    }
    previousNumbers.add(page);
  }
  return true;
}

PageUpdate transformInvalid(PageUpdate update, List<PageOrderRule> rules) {
  List<int> copied = List.from(update.pages);

  // get index of first invalid page
  int invalidIndex;
  for (invalidIndex = 0; invalidIndex < copied.length; invalidIndex++) {
    if (!isValid(copied.sublist(0, invalidIndex + 1), rules)) {
      break;
    }
  }

  final invalidNum = copied[invalidIndex];
  final List<int> beforeIndex = getPagesNeededBefore(invalidNum, copied, rules);

  copied.removeAt(invalidIndex);
  if (beforeIndex.isEmpty) {
    // simply add it to the front
    copied.insert(0, invalidNum);
  } else {
    final int maxBeforeIndex = beforeIndex
        .map((i) => copied.indexOf(i))
        .reduce((a, b) => a > b ? a : b);
    // insert after that index
    copied.insert(maxBeforeIndex + 1, invalidNum);
  }

  if (!isValid(List.from(copied), rules)) {
    return transformInvalid(PageUpdate(copied), rules);
  }

  return PageUpdate(copied);
}

class Day05Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final (rules, updates) = parseInput(inputLines);
    int acc = 0;
    for (PageUpdate u in updates) {
      if (isValid(u.pages, rules)) acc += u.getMiddlePage();
    }
    return acc;
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    final (rules, updates) = parseInput(inputLines);
    int acc = 0;
    for (PageUpdate u in updates) {
      if (!isValid(u.pages, rules)) {
        acc += transformInvalid(u, rules).getMiddlePage();
      }
    }
    return acc;
  }
}