import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:resto_dicodingsubs/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("integrate all feature", (tester) async {
    // Call the app's main() to ensure the MultiProvider (and ThemeProvider) is set up
    app.main();
    await tester.pumpAndSettle();

    final Finder searchButton = find.byKey(const Key('searchButton'));
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'kafe kita');
    final submitSearch = find.widgetWithIcon(IconButton, Icons.search);
    expect(submitSearch, findsOneWidget);
    await tester.tap(submitSearch);
    await tester.pumpAndSettle();

    final Finder searchResult = find.byType(ListView);
    expect(searchResult, findsOneWidget);

    expect(find.text("Gorontalo"), findsOne);
  });
}
