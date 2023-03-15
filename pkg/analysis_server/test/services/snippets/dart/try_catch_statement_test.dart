// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/protocol_server.dart';
import 'package:analysis_server/src/services/snippets/dart/try_catch_statement.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'test_support.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(TryCatchStatementTest);
  });
}

@reflectiveTest
class TryCatchStatementTest extends DartSnippetProducerTest {
  @override
  final generator = TryCatchStatement.new;

  @override
  String get label => TryCatchStatement.label;

  @override
  String get prefix => TryCatchStatement.prefix;

  Future<void> test_tryCatch() async {
    var code = r'''
void f() {
  tr^
}''';
    final snippet = await expectValidSnippet(code);
    expect(snippet.prefix, prefix);
    expect(snippet.label, label);
    expect(snippet.change.edits, hasLength(1));
    code = withoutMarkers(code);
    for (var edit in snippet.change.edits) {
      code = SourceEdit.applySequence(code, edit.edits);
    }
    expect(code, '''
void f() {
  try {
    
  } catch (e) {
    
  }
}''');
    expect(snippet.change.selection!.file, testFile);
    expect(snippet.change.selection!.offset, 23);
    expect(snippet.change.linkedEditGroups.map((group) => group.toJson()), [
      {
        'positions': [
          {'file': testFile, 'offset': 35},
        ],
        'length': 1,
        'suggestions': []
      }
    ]);
  }

  Future<void> test_tryCatch_indentedInsideBlock() async {
    var code = r'''
void f() {
  if (true) {
    tr^
  }
}''';
    final snippet = await expectValidSnippet(code);
    expect(snippet.prefix, prefix);
    expect(snippet.label, label);
    expect(snippet.change.edits, hasLength(1));
    code = withoutMarkers(code);
    for (var edit in snippet.change.edits) {
      code = SourceEdit.applySequence(code, edit.edits);
    }
    expect(code, '''
void f() {
  if (true) {
    try {
      
    } catch (e) {
      
    }
  }
}''');
    expect(snippet.change.selection!.file, testFile);
    expect(snippet.change.selection!.offset, 41);
    expect(snippet.change.linkedEditGroups.map((group) => group.toJson()), [
      {
        'positions': [
          {'file': testFile, 'offset': 55},
        ],
        'length': 1,
        'suggestions': []
      }
    ]);
  }
}