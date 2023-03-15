// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/protocol_server.dart';
import 'package:analysis_server/src/services/snippets/dart/test_definition.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'test_support.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(TestDefinitionTest);
  });
}

@reflectiveTest
class TestDefinitionTest extends DartSnippetProducerTest {
  @override
  final generator = TestDefinition.new;

  @override
  String get label => TestDefinition.label;

  @override
  String get prefix => TestDefinition.prefix;

  Future<void> test_inTestFile() async {
    testFile = convertPath('$testPackageLibPath/test/foo_test.dart');
    var code = r'''
void f() {
  test^
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
  test('test name', () {
    
  });
}''');
    expect(snippet.change.selection!.file, testFile);
    expect(snippet.change.selection!.offset, 40);
    expect(snippet.change.linkedEditGroups.map((group) => group.toJson()), [
      {
        'positions': [
          {'file': testFile, 'offset': 19},
        ],
        'length': 9,
        'suggestions': []
      }
    ]);
  }

  Future<void> test_notTestFile() async {
    var code = r'''
void f() {
  test^
}''';
    await expectNotValidSnippet(code);
  }
}