// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/protocol_server.dart';
import 'package:analysis_server/src/services/snippets/dart/for_statement.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'test_support.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ForStatementTest);
  });
}

@reflectiveTest
class ForStatementTest extends DartSnippetProducerTest {
  @override
  final generator = ForStatement.new;

  @override
  String get label => ForStatement.label;

  @override
  String get prefix => ForStatement.prefix;

  Future<void> test_for() async {
    var code = r'''
void f() {
  for^
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
  for (var i = 0; i < count; i++) {
    
  }
}''');
    expect(snippet.change.selection!.file, testFile);
    expect(snippet.change.selection!.offset, 51);
    expect(snippet.change.linkedEditGroups.map((group) => group.toJson()), [
      {
        'positions': [
          {'file': testFile, 'offset': 33},
        ],
        'length': 5,
        'suggestions': []
      }
    ]);
  }
}