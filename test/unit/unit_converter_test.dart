import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/unit_converter.dart';

void main() {
  group('UnitConverter', () {
    test('should convert length units correctly', () {
      expect(UnitConverter.convertLength(1, 'm', 'cm'), 100.0);
      expect(UnitConverter.convertLength(1000, 'm', 'km'), 1.0);
      expect(UnitConverter.convertLength(1, 'inch', 'cm'), closeTo(2.54, 0.01));
      expect(UnitConverter.convertLength(1, 'ft', 'm'), closeTo(0.3048, 0.001));
    });

    test('should convert mass units correctly', () {
      expect(UnitConverter.convertMass(1, 'kg', 'g'), 1000.0);
      expect(UnitConverter.convertMass(1000, 'g', 'kg'), 1.0);
      expect(UnitConverter.convertMass(1, 'lb', 'kg'), closeTo(0.453592, 0.001));
      expect(UnitConverter.convertMass(1, 'oz', 'g'), closeTo(28.3495, 0.1));
    });

    test('should convert volume units correctly', () {
      expect(UnitConverter.convertVolume(1, 'L', 'mL'), 1000.0);
      expect(UnitConverter.convertVolume(1000, 'mL', 'L'), 1.0);
      expect(UnitConverter.convertVolume(1, 'gallon', 'L'), closeTo(3.78541, 0.01));
      expect(UnitConverter.convertVolume(1, 'cup', 'mL'), closeTo(236.588, 0.1));
    });

    test('should convert temperature units correctly', () {
      expect(UnitConverter.convertTemperature(0, 'C', 'F'), 32.0);
      expect(UnitConverter.convertTemperature(100, 'C', 'F'), 212.0);
      expect(UnitConverter.convertTemperature(32, 'F', 'C'), 0.0);
      expect(UnitConverter.convertTemperature(212, 'F', 'C'), 100.0);
      expect(UnitConverter.convertTemperature(0, 'C', 'K'), 273.15);
      expect(UnitConverter.convertTemperature(273.15, 'K', 'C'), 0.0);
    });

    test('should convert speed units correctly', () {
      expect(UnitConverter.convertSpeed(1, 'm/s', 'km/h'), 3.6);
      expect(UnitConverter.convertSpeed(1, 'km/h', 'm/s'), closeTo(0.277778, 0.001));
      expect(UnitConverter.convertSpeed(1, 'mph', 'km/h'), closeTo(1.60934, 0.001));
      expect(UnitConverter.convertSpeed(1, 'knot', 'km/h'), 1.852);
    });

    test('should convert energy units correctly', () {
      expect(UnitConverter.convertEnergy(1, 'J', 'kJ'), 0.001);
      expect(UnitConverter.convertEnergy(1, 'kJ', 'J'), 1000.0);
      expect(UnitConverter.convertEnergy(1, 'cal', 'J'), 4.184);
      expect(UnitConverter.convertEnergy(1, 'kcal', 'J'), 4184.0);
      expect(UnitConverter.convertEnergy(1, 'Wh', 'J'), 3600.0);
      expect(UnitConverter.convertEnergy(1, 'kWh', 'J'), 3600000.0);
    });

    test('should convert pressure units correctly', () {
      expect(UnitConverter.convertPressure(1, 'Pa', 'kPa'), 0.001);
      expect(UnitConverter.convertPressure(1, 'kPa', 'Pa'), 1000.0);
      expect(UnitConverter.convertPressure(1, 'bar', 'Pa'), 100000.0);
      expect(UnitConverter.convertPressure(1, 'atm', 'Pa'), 101325.0);
      expect(UnitConverter.convertPressure(1, 'psi', 'Pa'), closeTo(6894.76, 0.1));
    });

    test('should convert area units correctly', () {
      expect(UnitConverter.convertArea(1, 'm²', 'cm²'), 10000.0);
      expect(UnitConverter.convertArea(1, 'cm²', 'm²'), 0.0001);
      expect(UnitConverter.convertArea(1, 'ft²', 'm²'), closeTo(0.092903, 0.001));
      expect(UnitConverter.convertArea(1, 'acre', 'm²'), closeTo(4046.86, 0.1));
    });

    test('should convert time units correctly', () {
      expect(UnitConverter.convertTime(1, 's', 'ms'), 1000.0);
      expect(UnitConverter.convertTime(1, 'ms', 's'), 0.001);
      expect(UnitConverter.convertTime(1, 'min', 's'), 60.0);
      expect(UnitConverter.convertTime(1, 'h', 's'), 3600.0);
      expect(UnitConverter.convertTime(1, 'day', 'h'), 24.0);
      expect(UnitConverter.convertTime(1, 'week', 'day'), 7.0);
      expect(UnitConverter.convertTime(1, 'year', 'day'), 365.25);
    });

    test('should convert angle units correctly', () {
      expect(UnitConverter.convertAngle(180, 'deg', 'rad'), closeTo(3.14159, 0.001));
      expect(UnitConverter.convertAngle(3.14159, 'rad', 'deg'), closeTo(180, 0.1));
      expect(UnitConverter.convertAngle(90, 'deg', 'grad'), 100.0);
      expect(UnitConverter.convertAngle(100, 'grad', 'deg'), 90.0);
    });

    test('should convert data units correctly', () {
      expect(UnitConverter.convertData(1, 'B', 'KB'), 0.001);
      expect(UnitConverter.convertData(1, 'KB', 'B'), 1000.0);
      expect(UnitConverter.convertData(1, 'MB', 'KB'), 1000.0);
      expect(UnitConverter.convertData(1, 'GB', 'MB'), 1000.0);
      expect(UnitConverter.convertData(1, 'TB', 'GB'), 1000.0);
    });

    test('should handle invalid unit conversions', () {
      expect(() => UnitConverter.convertLength(1, 'invalid', 'm'), throwsArgumentError);
      expect(() => UnitConverter.convertLength(1, 'm', 'invalid'), throwsArgumentError);
      expect(() => UnitConverter.convertMass(1, 'invalid', 'kg'), throwsArgumentError);
      expect(() => UnitConverter.convertVolume(1, 'invalid', 'L'), throwsArgumentError);
    });

    test('should handle same unit conversions', () {
      expect(UnitConverter.convertLength(5, 'm', 'm'), 5.0);
      expect(UnitConverter.convertMass(10, 'kg', 'kg'), 10.0);
      expect(UnitConverter.convertVolume(2, 'L', 'L'), 2.0);
      expect(UnitConverter.convertTemperature(25, 'C', 'C'), 25.0);
    });

    test('should handle zero values', () {
      expect(UnitConverter.convertLength(0, 'm', 'cm'), 0.0);
      expect(UnitConverter.convertMass(0, 'kg', 'g'), 0.0);
      expect(UnitConverter.convertVolume(0, 'L', 'mL'), 0.0);
      expect(UnitConverter.convertTemperature(0, 'C', 'F'), 32.0);
    });

    test('should handle negative values', () {
      expect(UnitConverter.convertLength(-1, 'm', 'cm'), -100.0);
      expect(UnitConverter.convertMass(-1, 'kg', 'g'), -1000.0);
      expect(UnitConverter.convertVolume(-1, 'L', 'mL'), -1000.0);
      expect(UnitConverter.convertTemperature(-40, 'C', 'F'), -40.0);
    });

    test('should handle large values', () {
      expect(UnitConverter.convertLength(1000000, 'm', 'km'), 1000.0);
      expect(UnitConverter.convertMass(1000000, 'g', 'kg'), 1000.0);
      expect(UnitConverter.convertVolume(1000000, 'mL', 'L'), 1000.0);
    });

    test('should handle small values', () {
      expect(UnitConverter.convertLength(0.001, 'm', 'mm'), 1.0);
      expect(UnitConverter.convertMass(0.001, 'kg', 'g'), 1.0);
      expect(UnitConverter.convertVolume(0.001, 'L', 'mL'), 1.0);
    });
  });
}
