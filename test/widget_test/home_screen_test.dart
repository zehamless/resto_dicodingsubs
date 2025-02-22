import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:resto_dicodingsubs/model/restaurant_menu.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';
import 'package:resto_dicodingsubs/screen/home/home_screen.dart';
import 'package:resto_dicodingsubs/static/restaurant_list_result_state.dart';

class FakeRestoListProvider extends ChangeNotifier
    implements RestoListProvider {
  RestoListResultState _resultState = RestoListResultNone();

  @override
  RestoListResultState get resultState => _resultState;

  void setResultState(RestoListResultState state) {
    _resultState = state;
    notifyListeners();
  }

  @override
  Future<void> fetchRestoList() async {}
}

class FakeThemeProvider extends ChangeNotifier implements ThemeProvider {
  @override
  ThemeMode themeMode = ThemeMode.light;

  @override
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

void main() {
  group('HomeScreen Widget Tests', () {
    late FakeRestoListProvider fakeRestoListProvider;
    late FakeThemeProvider fakeThemeProvider;
    late Widget widgetUnderTest;

    setUp(() {
      fakeRestoListProvider = FakeRestoListProvider();
      fakeThemeProvider = FakeThemeProvider();
      widgetUnderTest = MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<RestoListProvider>.value(
              value: fakeRestoListProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>.value(
              value: fakeThemeProvider,
            ),
          ],
          child: const HomeScreen(),
        ),
      );
    });

    testWidgets(
        "Memiliki AppBar, list area, dan PopMenu ketika pertama kali diluncurkan",
        (tester) async {
      fakeRestoListProvider.setResultState(RestoListResultNone());
      await tester.pumpWidget(widgetUnderTest);
      await tester.pumpAndSettle();

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final textInAppBarFinder = find.descendant(
          of: appBarFinder, matching: find.text('RestoDicodingSubs'));
      expect(textInAppBarFinder, findsOneWidget);

      expect(find.byKey(const Key("defaultState")), findsOneWidget);
      expect(find.byKey(const Key("searchButton")), findsOneWidget);
    });

    testWidgets(
        'Menampilkan indikator loading ketika state adalah RestoListResultLoading',
        (tester) async {
      fakeRestoListProvider.setResultState(RestoListResultLoading());
      await tester.pumpWidget(widgetUnderTest);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'Menampilkan daftar restoran ketika state adalah RestoListResultLoaded',
        (tester) async {
      final restaurant = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'Test Description',
        city: 'Test City',
        address: 'Test Address',
        pictureId: '1',
        rating: 4.5,
        categories: [],
        menus: Menu(foods: [], drinks: []),
        customerReviews: [],
      );
      fakeRestoListProvider.setResultState(RestoListResultLoaded([restaurant]));

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(widgetUnderTest);
        await tester.pumpAndSettle();

        expect(find.text('Test Restaurant'), findsOneWidget);
      });
    });

    testWidgets(
        'Menampilkan pesan error ketika state adalah RestoListResultError',
        (tester) async {
      fakeRestoListProvider
          .setResultState(RestoListResultError('Error fetching data'));
      await tester.pumpWidget(widgetUnderTest);
      await tester.pumpAndSettle();

      expect(find.text('Error fetching data'), findsOneWidget);
    });
  });
}
