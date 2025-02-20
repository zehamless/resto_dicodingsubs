import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:resto_dicodingsubs/model/restaurant_menu.dart';
import 'package:resto_dicodingsubs/model/restaurant_response.dart';
import 'package:resto_dicodingsubs/provider/searchlist/restaurant_search_list_provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';
import 'package:resto_dicodingsubs/screen/searchlist/restaurant_search_list_screen.dart';
import 'package:resto_dicodingsubs/service/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/unit_test/restaurant_list_provider_test.mocks.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPreferencesService = SharedPreferencesService(sharedPreferences);

  final mockApiService = MockApiService();

  group('Search Feature Integration Test', () {
    testWidgets('Menampilkan hasil search', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(mockApiService.searchRestaurants(any)).thenAnswer(
          (_) async => RestoResponse(
            error: false,
            message: 'success',
            restaurants: [
              Restaurant(
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
              )
            ],
          ),
        );

        final widget = MultiProvider(
          providers: [
            Provider<ApiService>.value(value: mockApiService),
            Provider<SharedPreferencesService>.value(
                value: sharedPreferencesService),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) =>
                  ThemeProvider(context.read<SharedPreferencesService>()),
            ),
            ChangeNotifierProvider<RestoSearchProvider>(
              create: (context) =>
                  RestoSearchProvider(context.read<ApiService>()),
            ),
          ],
          child: const MaterialApp(home: SearchScreen()),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Test');
        await tester.pump();

        final searchIconButton = find.widgetWithIcon(IconButton, Icons.search);
        expect(searchIconButton, findsOneWidget);
        await tester.tap(searchIconButton);
        await tester.pumpAndSettle();

        expect(find.text('Test Restaurant'), findsOneWidget);
      });
    });

    testWidgets('Tidak menampilkan hasil search', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        when(mockApiService.searchRestaurants(any)).thenAnswer(
          (_) async => RestoResponse(
            error: false,
            message: 'success',
            restaurants: [],
          ),
        );

        final widget = MultiProvider(
          providers: [
            Provider<ApiService>.value(value: mockApiService),
            Provider<SharedPreferencesService>.value(
                value: sharedPreferencesService),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) =>
                  ThemeProvider(context.read<SharedPreferencesService>()),
            ),
            ChangeNotifierProvider<RestoSearchProvider>(
              create: (context) =>
                  RestoSearchProvider(context.read<ApiService>()),
            ),
          ],
          child: const MaterialApp(home: SearchScreen()),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Toko');
        await tester.pump();

        final searchIconButton = find.widgetWithIcon(IconButton, Icons.search);
        expect(searchIconButton, findsOneWidget);
        await tester.tap(searchIconButton);
        await tester.pumpAndSettle();

        expect(find.text('Test Restaurant'), findsNothing);
      });
    });
  });
}
