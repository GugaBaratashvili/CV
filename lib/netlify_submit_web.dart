// Web: call JS to submit Netlify form (honeypot + optional CAPTCHA handled by Netlify).
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js_util' as js_util;

void submitNetlifyCvForm(String type) {
  try {
    js_util.callMethod(html.window, 'submitNetlifyCvForm', [type]);
  } catch (_) {
    // Ignore if form or JS not present (e.g. not on Netlify)
  }
}
