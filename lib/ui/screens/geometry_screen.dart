import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/geometry_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class GeometryScreen extends ConsumerStatefulWidget {
  const GeometryScreen({super.key});

  @override
  ConsumerState<GeometryScreen> createState() => _GeometryScreenState();
}

class _GeometryScreenState extends ConsumerState<GeometryScreen> {
  String _selectedCategory = '2D Shapes';
  String _selectedShape = 'Circle';
  final Map<String, TextEditingController> _controllers = {};
  String _result = '';
  bool _isTTSEnabled = false;

  final Map<String, List<String>> _categories = {
    '2D Shapes': ['Circle', 'Triangle', 'Rectangle', 'Square', 'Parallelogram', 'Trapezoid', 'Ellipse', 'Regular Polygon'],
    '3D Shapes': ['Sphere', 'Cube', 'Rectangular Prism', 'Cylinder', 'Cone', 'Pyramid', 'Triangular Prism'],
    'Coordinate Geometry': ['Distance', 'Midpoint', 'Slope', 'Line Equation', 'Angle Between Lines'],
    'Transformations': ['Rotation', 'Scaling', 'Translation'],
  };

  final Map<String, List<String>> _shapeFields = {
    'Circle': ['radius'],
    'Triangle': ['base', 'height'],
    'Rectangle': ['length', 'width'],
    'Square': ['side'],
    'Parallelogram': ['base', 'height'],
    'Trapezoid': ['base1', 'base2', 'height'],
    'Ellipse': ['semiMajorAxis', 'semiMinorAxis'],
    'Regular Polygon': ['sideLength', 'numberOfSides'],
    'Sphere': ['radius'],
    'Cube': ['side'],
    'Rectangular Prism': ['length', 'width', 'height'],
    'Cylinder': ['radius', 'height'],
    'Cone': ['radius', 'height'],
    'Pyramid': ['baseArea', 'height'],
    'Triangular Prism': ['baseArea', 'height'],
    'Distance': ['x1', 'y1', 'x2', 'y2'],
    'Midpoint': ['x1', 'y1', 'x2', 'y2'],
    'Slope': ['x1', 'y1', 'x2', 'y2'],
    'Line Equation': ['x1', 'y1', 'x2', 'y2'],
    'Angle Between Lines': ['slope1', 'slope2'],
    'Rotation': ['x', 'y', 'angle', 'centerX', 'centerY'],
    'Scaling': ['x', 'y', 'scaleX', 'scaleY', 'centerX', 'centerY'],
    'Translation': ['x', 'y', 'deltaX', 'deltaY'],
  };

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _initializeControllers();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _initializeControllers() {
    for (final fields in _shapeFields.values) {
      for (final field in fields) {
        _controllers[field] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedShape = _categories[category]!.first;
      _result = '';
    });
  }

  void _onShapeChanged(String shape) {
    setState(() {
      _selectedShape = shape;
      _result = '';
    });
  }

  Future<void> _calculate() async {
    try {
      final fields = _shapeFields[_selectedShape]!;
      final values = <String, double>{};
      
      for (final field in fields) {
        final value = double.tryParse(_controllers[field]!.text);
        if (value == null) {
          _showError('Please enter a valid number for ${_getFieldLabel(field)}');
          return;
        }
        values[field] = value;
      }

      String result = '';
      
      switch (_selectedShape) {
        case 'Circle':
          result = 'Area: ${GeometryLogic.circleArea(values['radius']!).toStringAsFixed(2)} square units\n';
          result += 'Circumference: ${GeometryLogic.circleCircumference(values['radius']!).toStringAsFixed(2)} units';
          break;
        case 'Triangle':
          result = 'Area: ${GeometryLogic.triangleArea(values['base']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Rectangle':
          result = 'Area: ${GeometryLogic.rectangleArea(values['length']!, values['width']!).toStringAsFixed(2)} square units\n';
          result += 'Perimeter: ${GeometryLogic.rectanglePerimeter(values['length']!, values['width']!).toStringAsFixed(2)} units';
          break;
        case 'Square':
          result = 'Area: ${GeometryLogic.squareArea(values['side']!).toStringAsFixed(2)} square units\n';
          result += 'Perimeter: ${GeometryLogic.squarePerimeter(values['side']!).toStringAsFixed(2)} units';
          break;
        case 'Parallelogram':
          result = 'Area: ${GeometryLogic.parallelogramArea(values['base']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Trapezoid':
          result = 'Area: ${GeometryLogic.trapezoidArea(values['base1']!, values['base2']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Ellipse':
          result = 'Area: ${GeometryLogic.ellipseArea(values['semiMajorAxis']!, values['semiMinorAxis']!).toStringAsFixed(2)} square units';
          break;
        case 'Regular Polygon':
          result = 'Area: ${GeometryLogic.regularPolygonArea(values['sideLength']!, values['numberOfSides']!.toInt()).toStringAsFixed(2)} square units';
          break;
        case 'Sphere':
          result = 'Volume: ${GeometryLogic.sphereVolume(values['radius']!).toStringAsFixed(2)} cubic units\n';
          result += 'Surface Area: ${GeometryLogic.sphereSurfaceArea(values['radius']!).toStringAsFixed(2)} square units';
          break;
        case 'Cube':
          result = 'Volume: ${GeometryLogic.cubeVolume(values['side']!).toStringAsFixed(2)} cubic units\n';
          result += 'Surface Area: ${GeometryLogic.cubeSurfaceArea(values['side']!).toStringAsFixed(2)} square units';
          break;
        case 'Rectangular Prism':
          result = 'Volume: ${GeometryLogic.rectangularPrismVolume(values['length']!, values['width']!, values['height']!).toStringAsFixed(2)} cubic units\n';
          result += 'Surface Area: ${GeometryLogic.rectangularPrismSurfaceArea(values['length']!, values['width']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Cylinder':
          result = 'Volume: ${GeometryLogic.cylinderVolume(values['radius']!, values['height']!).toStringAsFixed(2)} cubic units\n';
          result += 'Surface Area: ${GeometryLogic.cylinderSurfaceArea(values['radius']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Cone':
          result = 'Volume: ${GeometryLogic.coneVolume(values['radius']!, values['height']!).toStringAsFixed(2)} cubic units\n';
          result += 'Surface Area: ${GeometryLogic.coneSurfaceArea(values['radius']!, values['height']!).toStringAsFixed(2)} square units';
          break;
        case 'Pyramid':
          result = 'Volume: ${GeometryLogic.pyramidVolume(values['baseArea']!, values['height']!).toStringAsFixed(2)} cubic units';
          break;
        case 'Triangular Prism':
          result = 'Volume: ${GeometryLogic.triangularPrismVolume(values['baseArea']!, values['height']!).toStringAsFixed(2)} cubic units';
          break;
        case 'Distance':
          result = 'Distance: ${GeometryLogic.distanceBetweenPoints(values['x1']!, values['y1']!, values['x2']!, values['y2']!).toStringAsFixed(2)} units';
          break;
        case 'Midpoint':
          final midpoint = GeometryLogic.midpoint(values['x1']!, values['y1']!, values['x2']!, values['y2']!);
          result = 'Midpoint: (${midpoint['x']!.toStringAsFixed(2)}, ${midpoint['y']!.toStringAsFixed(2)})';
          break;
        case 'Slope':
          result = 'Slope: ${GeometryLogic.slope(values['x1']!, values['y1']!, values['x2']!, values['y2']!).toStringAsFixed(2)}';
          break;
        case 'Line Equation':
          final equation = GeometryLogic.lineEquation(values['x1']!, values['y1']!, values['x2']!, values['y2']!);
          if (equation['type'] == 'vertical') {
            result = 'Line Equation: x = ${equation['x']!.toStringAsFixed(2)}';
          } else {
            result = 'Line Equation: y = ${equation['slope']!.toStringAsFixed(2)}x + ${equation['yIntercept']!.toStringAsFixed(2)}';
          }
          break;
        case 'Angle Between Lines':
          result = 'Angle: ${GeometryLogic.angleBetweenLines(values['slope1']!, values['slope2']!).toStringAsFixed(2)} degrees';
          break;
        case 'Rotation':
          final rotated = GeometryLogic.rotatePoint(values['x']!, values['y']!, values['angle']!, values['centerX']!, values['centerY']!);
          result = 'Rotated Point: (${rotated['x']!.toStringAsFixed(2)}, ${rotated['y']!.toStringAsFixed(2)})';
          break;
        case 'Scaling':
          final scaled = GeometryLogic.scalePoint(values['x']!, values['y']!, values['scaleX']!, values['scaleY']!, values['centerX']!, values['centerY']!);
          result = 'Scaled Point: (${scaled['x']!.toStringAsFixed(2)}, ${scaled['y']!.toStringAsFixed(2)})';
          break;
        case 'Translation':
          final translated = GeometryLogic.translatePoint(values['x']!, values['y']!, values['deltaX']!, values['deltaY']!);
          result = 'Translated Point: (${translated['x']!.toStringAsFixed(2)}, ${translated['y']!.toStringAsFixed(2)})';
          break;
      }

      setState(() {
        _result = result;
      });

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        await TTSService.speakCalculation(_selectedShape, result);
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _getFieldLabel(String field) {
    final labels = {
      'radius': 'Radius',
      'base': 'Base',
      'height': 'Height',
      'length': 'Length',
      'width': 'Width',
      'side': 'Side',
      'base1': 'Base 1',
      'base2': 'Base 2',
      'semiMajorAxis': 'Semi-Major Axis',
      'semiMinorAxis': 'Semi-Minor Axis',
      'sideLength': 'Side Length',
      'numberOfSides': 'Number of Sides',
      'baseArea': 'Base Area',
      'x1': 'X₁',
      'y1': 'Y₁',
      'x2': 'X₂',
      'y2': 'Y₂',
      'slope1': 'Slope 1',
      'slope2': 'Slope 2',
      'x': 'X',
      'y': 'Y',
      'angle': 'Angle',
      'centerX': 'Center X',
      'centerY': 'Center Y',
      'scaleX': 'Scale X',
      'scaleY': 'Scale Y',
      'deltaX': 'Delta X',
      'deltaY': 'Delta Y',
    };
    return labels[field] ?? field;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geometry Calculator'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareCalculation(_selectedShape, _result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => _onCategoryChanged(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Shape Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shape/Operation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedShape,
                      isExpanded: true,
                      items: _categories[_selectedCategory]!.map((shape) {
                        return DropdownMenuItem(
                          value: shape,
                          child: Text(shape),
                        );
                      }).toList(),
                      onChanged: (value) => _onShapeChanged(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Fields
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Values',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._shapeFields[_selectedShape]!.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _controllers[field],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(field),
                            border: const OutlineInputBorder(),
                            suffixText: _getUnit(field),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result Section
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Result',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isTTSEnabled)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await TTSService.speakCalculation(_selectedShape, _result);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Result copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _result,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getUnit(String field) {
    if (field.contains('Area') || field.contains('Surface')) return 'sq units';
    if (field.contains('Volume')) return 'cubic units';
    if (field.contains('Perimeter') || field.contains('Circumference') || field.contains('Distance')) return 'units';
    if (field.contains('Angle')) return 'degrees';
    return '';
  }
}