import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:resto_dicodingsubs/model/restaurant_menu.dart';
import 'package:resto_dicodingsubs/model/restaurant_response.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/static/restaurant_list_result_state.dart';

// Generate mock untuk ApiService dengan build_runner
@GenerateMocks([ApiService])
import 'restaurant_list_provider_test.mocks.dart';

void main() {
  group('RestoListProvider Tests', () {
    late RestoListProvider provider;
    late MockApiService mockApiService;

    setUp(() {
      // Gunakan mock yang dihasilkan oleh build_runner
      mockApiService = MockApiService();
      provider = RestoListProvider(mockApiService);
    });

    test(
      'State awal provider harus didefinisikan sebagai RestoListResultNone',
      () {
        expect(provider.resultState, isA<RestoListResultNone>());
      },
    );

    test(
      'Harus mengembalikan daftar restoran ketika pengambilan data API berhasil',
      () async {
        // Arrange
        final restaurant = Restaurant(
          id: 'some_restaurant_id',
          name: 'Test Restaurant',
          description: 'Test Description',
          city: 'Test City',
          address: 'Test Address',
          pictureId: 'test_picture_id',
          rating: 4.5,
          categories: [],
          menus: Menu(foods: [], drinks: []),
          customerReviews: [],
        );
        // Stub getRestaurants untuk mengembalikan RestoResponse dengan daftar restoran
        when(mockApiService.getRestaurants())
            .thenAnswer((_) async => RestoResponse(
                  error: false,
                  message: 'Success',
                  restaurants: [restaurant],
                ));

        // Act
        await provider.fetchRestoList();

        // Assert
        verify(mockApiService.getRestaurants()).called(1);
        expect(provider.resultState, isA<RestoListResultLoaded>());
        final loadedState = provider.resultState as RestoListResultLoaded;
        expect(loadedState.data.length, equals(1));
        expect(loadedState.data.first.name, equals('Test Restaurant'));
      },
    );

    test(
      'Harus mengembalikan error ketika pengambilan data API gagal',
      () async {
        // Arrange
        when(mockApiService.getRestaurants())
            .thenAnswer((_) async => Future.error(Exception('API error')));

        // Act
        await provider.fetchRestoList();

        // Assert
        verify(mockApiService.getRestaurants()).called(1);
        expect(provider.resultState, isA<RestoListResultError>());
        final errorState = provider.resultState as RestoListResultError;
        expect(errorState.error, equals('Error fetching data'));
      },
    );
  });
}
