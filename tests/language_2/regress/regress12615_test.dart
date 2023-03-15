// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

// Test that try-catch works properly in the VM.

main() {
  void test() {
    f() {
      try {} catch (e) {}
    }

    try {} catch (e) {}
  }

  test();
}