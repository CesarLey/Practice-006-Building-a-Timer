import 'package:flutter_test/flutter_test.dart';
import 'package:kiritochi/core/app/timer_app.dart';

void main() {
  testWidgets('TimerApp has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const TimerApp());

    expect(find.text('Timer'), findsOneWidget);
  });
}