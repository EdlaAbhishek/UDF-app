import 'package:flutter_test/flutter_test.dart';
import 'package:khushi_hygieia/main.dart';

void main() {
  testWidgets('Khushi Hygieia smoke test', (WidgetTester tester) async {
    // Build app widget
    await tester.pumpWidget(const KhushiHygieiaApp());
    expect(find.byType(KhushiHygieiaApp), findsOneWidget);
  });
}
