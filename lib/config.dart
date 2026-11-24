import 'package:flutter/foundation.dart';

/// Debug emulator uses the host bridge; release defaults to HTTPS.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: kReleaseMode
      ? 'https://muhammad-osman-myportofolio.pws.cs.ui.ac.id'
      : 'http://10.0.2.2:8000',
);
