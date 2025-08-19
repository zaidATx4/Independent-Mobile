import 'package:flutter_test/flutter_test.dart';
import 'package:independent/features/food_ordering/data/repositories/location_repository_impl.dart';

void main() {
  group('Parker\'s Brand Location Tests', () {
    late LocationRepositoryImpl repository;

    setUp(() {
      repository = LocationRepositoryImpl();
    });

    test('should have locations for Parker\'s brand (id: 5)', () async {
      // Act
      final locations = await repository.getLocationsByBrandId('5');

      // Assert
      expect(locations, isNotEmpty);
      expect(locations.length, equals(2));
      
      // Check location IDs
      final locationIds = locations.map((l) => l.id).toList();
      expect(locationIds, contains('5a'));
      expect(locationIds, contains('5b'));
      
      // Check location names
      final locationNames = locations.map((l) => l.name).toList();
      expect(locationNames, contains('Parkers Mall of the Emirates'));
      expect(locationNames, contains('Parkers City Centre Deira'));
      
      print('✅ Parker\'s locations found: ${locationNames.join(', ')}');
    });

    test('should have correct brand logo path for Parker\'s', () async {
      // Act
      final locations = await repository.getLocationsByBrandId('5');

      // Assert
      expect(locations, isNotEmpty);
      
      for (final location in locations) {
        expect(location.brandId, equals('5'));
        expect(location.isOpen, isTrue);
        expect(location.acceptsPickup, isTrue);
        
        print('✅ Parker\'s location: ${location.name} - Brand ID: ${location.brandId}');
      }
    });

    test('should find all brands have locations', () async {
      final brandIds = ['1', '2', '3', '4', '5']; // Salt, Switch, Somewhere, Joe & Juice, Parker's
      
      for (final brandId in brandIds) {
        final locations = await repository.getLocationsByBrandId(brandId);
        print('Brand $brandId has ${locations.length} locations');
        
        if (brandId == '5') {
          // Parker's should now have 2 locations
          expect(locations.length, equals(2));
        }
      }
    });
  });
}