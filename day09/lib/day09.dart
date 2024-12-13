import 'dart:async';

import 'package:aoc/aoc.dart';

class Block {
  final int? id;

  const Block(this.id);
  const Block.free() : id = null;

  bool get isFile => id != null;
  bool get isFreeSpace => id == null;

  @override
  String toString() {
    return '${id == null ? '.' : id}';
  }
}

class DiskMap {
  final List<Block> blocks;

  const DiskMap(this.blocks);

  factory DiskMap.fromInput(String input) {
    final List<Block> entries = [];

    int fileId = 0;
    for (int i = 0; i < input.length; i++) {
      final length = int.parse(input[i]);
      entries.addAll(List.generate(length, (_) => Block(i % 2 != 0 ? null : fileId)));
      if (i % 2 == 0) {
        fileId++;
      }
    }

    return DiskMap(entries);
  }

  bool isFileBetween(int start, int end) {
    for (int i = start + 1; i < end; i++) {
      if (blocks[i].isFile) {
        return true;
      }
    }
    return false;
  }

  int getNextFree() => blocks.indexWhere((b) => b.isFreeSpace);
  int getNextUsed() => blocks.lastIndexWhere((b) => b.isFile);
}

DiskMap putLastBlockToFront(DiskMap map) {
  final List<Block> blocks = List.of(map.blocks);

  final int lastUsed = map.getNextUsed();
  blocks[map.getNextFree()] = blocks[lastUsed];
  blocks[lastUsed] = Block.free();

  return DiskMap(blocks);
}

DiskMap fragmentMap(DiskMap initialMap) {
  DiskMap map = DiskMap(initialMap.blocks);

  while (map.isFileBetween(map.getNextFree(), map.blocks.length)) {
    map = putLastBlockToFront(map);
  }
  return map;
}

int calculateChecksum(DiskMap map) {
  int checksum = 0;
  for (int i = 0; i < map.blocks.length; i++) {
    if (map.blocks[i].isFile) {
      checksum += i * map.blocks[i].id!;
    }
  }
  return checksum;
}

class Day09Challenge implements AOCChallenge<int> {
  @override
  FutureOr<int> part1(String input, List<String> inputLines) {
    final diskMap = DiskMap.fromInput(input);
    return calculateChecksum(fragmentMap(diskMap));
  }

  @override
  FutureOr<int> part2(String input, List<String> inputLines) {
    throw UnimplementedError();
  }
}
