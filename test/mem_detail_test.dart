import 'package:flutter_test/flutter_test.dart';
import 'package:mem/app.dart';

void main() {
  testWidgets('Show empty mem detail.',
      (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text(''), findsWidgets);

    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
