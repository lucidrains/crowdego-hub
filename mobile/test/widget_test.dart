import 'package:crowdego_hub/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the starter home screen', (tester) async {
    await tester.pumpWidget(const CrowdegoApp());

    expect(find.text('Crowdego Hub'), findsOneWidget);
    expect(find.text('Egocentric demonstrations'), findsOneWidget);
    expect(
      find.text('Camera capture and uploads are not connected yet.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
  });

  testWidgets('fits a small screen with enlarged text', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const CrowdegoApp());

    expect(tester.takeException(), isNull);
  });
}
