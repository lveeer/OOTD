import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ootd/main.dart';
import 'package:ootd/core/di/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    // 初始化依赖注入容器
    TestWidgetsFlutterBinding.ensureInitialized();
    await di.configureDependencies();
  });

  testWidgets('OOTD app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OOTDApp());

    // Trigger a few frames to allow initial animations and async operations to start
    await tester.pump();
    
    // Wait for the FeedBloc's async operation to complete (500ms delay)
    await tester.pump(const Duration(milliseconds: 600));

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
