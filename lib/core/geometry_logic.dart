import 'dart:math' as math;

class GeometryLogic {
  // 2D Shapes - Area calculations
  static double circleArea(double radius) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return math.pi * radius * radius;
  }
  
  static double circleCircumference(double radius) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return 2 * math.pi * radius;
  }
  
  static double triangleArea(double base, double height) {
    if (base < 0 || height < 0) throw ArgumentError('Base and height cannot be negative');
    return 0.5 * base * height;
  }
  
  static double triangleAreaHeron(double a, double b, double c) {
    if (a < 0 || b < 0 || c < 0) throw ArgumentError('Sides cannot be negative');
    if (a + b <= c || a + c <= b || b + c <= a) {
      throw ArgumentError('Invalid triangle: sum of any two sides must be greater than the third');
    }
    
    final s = (a + b + c) / 2;
    return math.sqrt(s * (s - a) * (s - b) * (s - c));
  }
  
  static double rectangleArea(double length, double width) {
    if (length < 0 || width < 0) throw ArgumentError('Length and width cannot be negative');
    return length * width;
  }
  
  static double rectanglePerimeter(double length, double width) {
    if (length < 0 || width < 0) throw ArgumentError('Length and width cannot be negative');
    return 2 * (length + width);
  }
  
  static double squareArea(double side) {
    if (side < 0) throw ArgumentError('Side cannot be negative');
    return side * side;
  }
  
  static double squarePerimeter(double side) {
    if (side < 0) throw ArgumentError('Side cannot be negative');
    return 4 * side;
  }
  
  static double parallelogramArea(double base, double height) {
    if (base < 0 || height < 0) throw ArgumentError('Base and height cannot be negative');
    return base * height;
  }
  
  static double trapezoidArea(double base1, double base2, double height) {
    if (base1 < 0 || base2 < 0 || height < 0) {
      throw ArgumentError('Bases and height cannot be negative');
    }
    return 0.5 * (base1 + base2) * height;
  }
  
  static double ellipseArea(double semiMajorAxis, double semiMinorAxis) {
    if (semiMajorAxis < 0 || semiMinorAxis < 0) {
      throw ArgumentError('Semi-axes cannot be negative');
    }
    return math.pi * semiMajorAxis * semiMinorAxis;
  }
  
  static double regularPolygonArea(double sideLength, int numberOfSides) {
    if (sideLength < 0 || numberOfSides < 3) {
      throw ArgumentError('Invalid polygon parameters');
    }
    final apothem = sideLength / (2 * math.tan(math.pi / numberOfSides));
    return 0.5 * numberOfSides * sideLength * apothem;
  }
  
  // 3D Shapes - Volume calculations
  static double sphereVolume(double radius) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return (4 / 3) * math.pi * radius * radius * radius;
  }
  
  static double sphereSurfaceArea(double radius) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return 4 * math.pi * radius * radius;
  }
  
  static double cubeVolume(double side) {
    if (side < 0) throw ArgumentError('Side cannot be negative');
    return side * side * side;
  }
  
  static double cubeSurfaceArea(double side) {
    if (side < 0) throw ArgumentError('Side cannot be negative');
    return 6 * side * side;
  }
  
  static double rectangularPrismVolume(double length, double width, double height) {
    if (length < 0 || width < 0 || height < 0) {
      throw ArgumentError('Dimensions cannot be negative');
    }
    return length * width * height;
  }
  
  static double rectangularPrismSurfaceArea(double length, double width, double height) {
    if (length < 0 || width < 0 || height < 0) {
      throw ArgumentError('Dimensions cannot be negative');
    }
    return 2 * (length * width + length * height + width * height);
  }
  
  static double cylinderVolume(double radius, double height) {
    if (radius < 0 || height < 0) throw ArgumentError('Radius and height cannot be negative');
    return math.pi * radius * radius * height;
  }
  
  static double cylinderSurfaceArea(double radius, double height) {
    if (radius < 0 || height < 0) throw ArgumentError('Radius and height cannot be negative');
    return 2 * math.pi * radius * (radius + height);
  }
  
  static double coneVolume(double radius, double height) {
    if (radius < 0 || height < 0) throw ArgumentError('Radius and height cannot be negative');
    return (1 / 3) * math.pi * radius * radius * height;
  }
  
  static double coneSurfaceArea(double radius, double height) {
    if (radius < 0 || height < 0) throw ArgumentError('Radius and height cannot be negative');
    final slantHeight = math.sqrt(radius * radius + height * height);
    return math.pi * radius * (radius + slantHeight);
  }
  
  static double pyramidVolume(double baseArea, double height) {
    if (baseArea < 0 || height < 0) throw ArgumentError('Base area and height cannot be negative');
    return (1 / 3) * baseArea * height;
  }
  
  static double triangularPrismVolume(double baseArea, double height) {
    if (baseArea < 0 || height < 0) throw ArgumentError('Base area and height cannot be negative');
    return baseArea * height;
  }
  
  // Coordinate Geometry
  static double distanceBetweenPoints(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
  }
  
  static Map<String, double> midpoint(double x1, double y1, double x2, double y2) {
    return {
      'x': (x1 + x2) / 2,
      'y': (y1 + y2) / 2,
    };
  }
  
  static double slope(double x1, double y1, double x2, double y2) {
    if (x2 == x1) throw ArgumentError('Vertical line: slope is undefined');
    return (y2 - y1) / (x2 - x1);
  }
  
  static Map<String, dynamic> lineEquation(double x1, double y1, double x2, double y2) {
    if (x2 == x1) {
      return {'type': 'vertical', 'x': x1};
    }
    
    final m = slope(x1, y1, x2, y2);
    final b = y1 - m * x1;
    
    return {'type': 'linear', 'slope': m, 'yIntercept': b};
  }
  
  // Pythagorean Theorem
  static double pythagoreanHypotenuse(double a, double b) {
    if (a < 0 || b < 0) throw ArgumentError('Sides cannot be negative');
    return math.sqrt(a * a + b * b);
  }
  
  static double pythagoreanLeg(double hypotenuse, double otherLeg) {
    if (hypotenuse < 0 || otherLeg < 0) throw ArgumentError('Sides cannot be negative');
    if (otherLeg >= hypotenuse) throw ArgumentError('Other leg must be less than hypotenuse');
    return math.sqrt(hypotenuse * hypotenuse - otherLeg * otherLeg);
  }
  
  // Angle calculations
  static double angleBetweenLines(double slope1, double slope2) {
    if (slope1 == slope2) return 0; // Parallel lines
    
    final angle = math.atan((slope2 - slope1) / (1 + slope1 * slope2));
    return (angle * 180 / math.pi).abs();
  }
  
  static double angleInTriangle(double a, double b, double c) {
    if (a < 0 || b < 0 || c < 0) throw ArgumentError('Sides cannot be negative');
    if (a + b <= c || a + c <= b || b + c <= a) {
      throw ArgumentError('Invalid triangle');
    }
    
    // Using Law of Cosines: c² = a² + b² - 2ab*cos(C)
    final cosC = (a * a + b * b - c * c) / (2 * a * b);
    final angleC = math.acos(cosC.clamp(-1.0, 1.0));
    return angleC * 180 / math.pi;
  }
  
  // Circle properties
  static double chordLength(double radius, double centralAngle) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return 2 * radius * math.sin(centralAngle * math.pi / 360);
  }
  
  static double arcLength(double radius, double centralAngle) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return radius * centralAngle * math.pi / 180;
  }
  
  static double sectorArea(double radius, double centralAngle) {
    if (radius < 0) throw ArgumentError('Radius cannot be negative');
    return 0.5 * radius * radius * centralAngle * math.pi / 180;
  }
  
  // Polygon properties
  static double polygonInteriorAngle(int numberOfSides) {
    if (numberOfSides < 3) throw ArgumentError('Polygon must have at least 3 sides');
    return (numberOfSides - 2) * 180 / numberOfSides;
  }
  
  static double polygonExteriorAngle(int numberOfSides) {
    if (numberOfSides < 3) throw ArgumentError('Polygon must have at least 3 sides');
    return 360 / numberOfSides;
  }
  
  static int polygonDiagonals(int numberOfSides) {
    if (numberOfSides < 3) throw ArgumentError('Polygon must have at least 3 sides');
    return numberOfSides * (numberOfSides - 3) ~/ 2;
  }
  
  // Transformations
  static Map<String, double> rotatePoint(double x, double y, double angle, double centerX, double centerY) {
    final radians = angle * math.pi / 180;
    final cosA = math.cos(radians);
    final sinA = math.sin(radians);
    
    final translatedX = x - centerX;
    final translatedY = y - centerY;
    
    final rotatedX = translatedX * cosA - translatedY * sinA;
    final rotatedY = translatedX * sinA + translatedY * cosA;
    
    return {
      'x': rotatedX + centerX,
      'y': rotatedY + centerY,
    };
  }
  
  static Map<String, double> scalePoint(double x, double y, double scaleX, double scaleY, double centerX, double centerY) {
    return {
      'x': (x - centerX) * scaleX + centerX,
      'y': (y - centerY) * scaleY + centerY,
    };
  }
  
  static Map<String, double> translatePoint(double x, double y, double deltaX, double deltaY) {
    return {
      'x': x + deltaX,
      'y': y + deltaY,
    };
  }
  
  // Geometric series and sequences
  static double geometricSeriesSum(double firstTerm, double ratio, int numberOfTerms) {
    if (ratio == 1) return firstTerm * numberOfTerms;
    return firstTerm * (1 - math.pow(ratio, numberOfTerms)) / (1 - ratio);
  }
  
  static double geometricSeriesInfiniteSum(double firstTerm, double ratio) {
    if (ratio.abs() >= 1) throw ArgumentError('Infinite series converges only when |ratio| < 1');
    return firstTerm / (1 - ratio);
  }
  
  // Golden ratio and Fibonacci
  static const double goldenRatio = 1.618033988749895;
  
  static double fibonacciNumber(int n) {
    if (n < 0) throw ArgumentError('Fibonacci sequence is not defined for negative numbers');
    if (n <= 1) return n.toDouble();
    
    double a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
      final temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  }
  
  // Utility functions
  static double degreesToRadians(double degrees) => degrees * math.pi / 180;
  static double radiansToDegrees(double radians) => radians * 180 / math.pi;
  
  static bool isPointInCircle(double pointX, double pointY, double centerX, double centerY, double radius) {
    final distance = distanceBetweenPoints(pointX, pointY, centerX, centerY);
    return distance <= radius;
  }
  
  static bool isPointInRectangle(double pointX, double pointY, double rectX, double rectY, double width, double height) {
    return pointX >= rectX && pointX <= rectX + width && pointY >= rectY && pointY <= rectY + height;
  }
}
