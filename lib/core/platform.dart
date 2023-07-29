import 'dart:io' as io;

import 'package:flutter/foundation.dart';

class Platform {
  static const isWeb = kIsWeb;

  static final isMacOS = !Platform.isWeb && io.Platform.isMacOS;
  static final isWindows = !Platform.isWeb && io.Platform.isWindows;
  static final isLinux = !Platform.isWeb && io.Platform.isLinux;
  static final isAndroid = !Platform.isWeb && io.Platform.isAndroid;
  static final isIOS = !Platform.isWeb && io.Platform.isIOS;
  static final isFuchsia = !Platform.isWeb && io.Platform.isFuchsia;

  static final isMobile = isAndroid || isIOS;
  static final isDesktop = isMacOS || isWindows || isLinux;
}
