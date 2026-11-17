import 'package:flutter_test/flutter_test.dart';
import 'package:portal/app.dart';

void main() {
  testWidgets('PORTAL setup screen explains backend configuration', (tester) async {
    await tester.pumpWidget(const PortalApp());
    expect(find.text('PORTAL'), findsOneWidget);
    expect(find.textContaining('proyecto Supabase'), findsOneWidget);
  });
}
