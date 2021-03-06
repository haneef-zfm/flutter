// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

import '../base/platform.dart';
import '../doctor.dart';
import 'chrome.dart';

/// A validator for Chromium-based brosers.
abstract class ChromiumValidator extends DoctorValidator {
  const ChromiumValidator(String title) : super(title);

  Platform get _platform;
  ChromiumLauncher get _chromiumLauncher;
  String get _name;

  @override
  Future<ValidationResult> validate() async {
    final bool canRunChromium = _chromiumLauncher.canFindExecutable();
    final String chromimSearchLocation = _chromiumLauncher.findExecutable();
    final List<ValidationMessage> messages = <ValidationMessage>[
      if (_platform.environment.containsKey(kChromeEnvironment))
        if (!canRunChromium)
          ValidationMessage.hint('$chromimSearchLocation is not executable.')
        else
          ValidationMessage('$kChromeEnvironment = $chromimSearchLocation')
      else
        if (!canRunChromium)
          ValidationMessage.hint('Cannot find $_name. Try setting '
            '$kChromeEnvironment to a $_name executable.')
        else
          ValidationMessage('$_name at $chromimSearchLocation'),
    ];
    if (!canRunChromium) {
      return ValidationResult(
        ValidationType.missing,
        messages,
        statusInfo: 'Cannot find $_name executable at $chromimSearchLocation',
      );
    }
    return ValidationResult(
      ValidationType.installed,
      messages,
    );
  }
}

/// A validator that checks whether Chrome is installed and can run.
class ChromeValidator extends ChromiumValidator {
  const ChromeValidator({
    @required Platform platform,
    @required ChromiumLauncher chromiumLauncher,
  }) : _platform = platform,
       _chromiumLauncher = chromiumLauncher,
       super('Chrome - develop for the web');

  @override
  final Platform _platform;

  @override
  final ChromiumLauncher _chromiumLauncher;

  @override
  String get _name => 'Chrome';
}

/// A validator that checks whethere Edge is installed and can run.
// This is not currently used, see https://github.com/flutter/flutter/issues/55322
class EdgeValidator extends ChromiumValidator {
  const EdgeValidator({
    @required Platform platform,
    @required ChromiumLauncher chromiumLauncher,
  }) : _platform = platform,
       _chromiumLauncher = chromiumLauncher,
       super('Edge - develop for the web');

  @override
  final Platform _platform;

  @override
  final ChromiumLauncher _chromiumLauncher;

  @override
  String get _name => 'Edge';
}
