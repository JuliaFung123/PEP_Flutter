import 'package:flutter_test/flutter_test.dart';
import 'package:pep_flutter/component_library/widgets/glass_media_brightness.dart';
import 'package:pep_flutter/component_library/widgets/image_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('analyzeImageMediaBrightness demo assets', () async {
    for (final asset in kDemoImageHeaderAssets) {
      final full = await analyzeImageMediaBrightness(
        imageProviderFor(asset),
        startYFraction: 0,
      );
      final band = await analyzeImageMediaBrightness(
        imageProviderFor(asset),
        startYFraction: 0.68,
      );
      // ignore: avoid_print
      print('$asset full=$full bottom=$band');
    }
  });
}
