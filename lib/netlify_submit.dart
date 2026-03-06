// Submits a CV submission event to Netlify Forms (web only; no-op on other platforms).
// Used for logging when user submits Student CV or Spouse CV; form has honeypot for spam.

import 'netlify_submit_stub.dart' if (dart.library.html) 'netlify_submit_web.dart' as impl;

void submitNetlifyCvForm(String type) => impl.submitNetlifyCvForm(type);
