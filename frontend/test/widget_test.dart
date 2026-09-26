import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/auth_provider.dart';

void main() {
  testWidgets('App loads cleanly test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MyafrimallApp(),
      ),
    );
    expect(find.byType(MyafrimallApp), findsOneWidget);
  });
}
