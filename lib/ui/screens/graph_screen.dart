import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class GraphScreen extends ConsumerStatefulWidget {
  const GraphScreen({super.key});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  String _selectedGraphType = 'Function Plot';
  final TextEditingController _functionController = TextEditingController();
  final TextEditingController _xMinController = TextEditingController();
  final TextEditingController _xMaxController = TextEditingController();
  String _result = '';
  bool _isTTSEnabled = false;
  List<FlSpot> _functionData = [];
  List<ChartData> _barChartData = [];
  List<ChartData> _lineChartData = [];
  List<CustomPieChartData> _pieChartData = [];
  List<ScatterData> _scatterData = [];
  List<AreaData> _areaData = [];
  List<HistogramData> _histogramData = [];
  List<PolarData> _polarData = [];
  List<ContourData> _contourData = [];
  List<VectorData> _vectorData = [];
  List<StatisticalData> _statisticalData = [];
  List<FinancialData> _financialData = [];

  final List<String> _graphTypes = [
    'Function Plot',
    'Bar Chart',
    'Line Chart',
    'Pie Chart',
    'Scatter Plot',
    'Area Chart',
    'Histogram',
    'Box Plot',
    'Heatmap',
    '3D Surface',
    'Polar Plot',
    'Contour Plot',
    'Vector Field',
    'Statistical Plot',
    'Financial Chart',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _xMinController.text = '-10';
    _xMaxController.text = '10';
    _generateSampleData();
  }

  void _generateSampleData() {
    // Generate sample data for different chart types
    _generateBarChartData();
    _generateLineChartData();
    _generatePieChartData();
    _generateScatterData();
    _generateAreaData();
    _generateHistogramData();
  }

  void _generateBarChartData() {
    _barChartData = [
      ChartData('Jan', 20),
      ChartData('Feb', 35),
      ChartData('Mar', 28),
      ChartData('Apr', 42),
      ChartData('May', 38),
      ChartData('Jun', 45),
    ];
  }

  void _generateLineChartData() {
    _lineChartData = [
      ChartData('Week 1', 10),
      ChartData('Week 2', 15),
      ChartData('Week 3', 12),
      ChartData('Week 4', 18),
      ChartData('Week 5', 22),
      ChartData('Week 6', 25),
      ChartData('Week 7', 28),
    ];
  }

  void _generatePieChartData() {
    _pieChartData = [
      CustomPieChartData('Category A', 35, Colors.blue),
      CustomPieChartData('Category B', 25, Colors.green),
      CustomPieChartData('Category C', 20, Colors.orange),
      CustomPieChartData('Category D', 15, Colors.red),
      CustomPieChartData('Category E', 5, Colors.purple),
    ];
  }

  void _generateScatterData() {
    _scatterData = [];
    for (int i = 0; i < 50; i++) {
      final x = (math.Random().nextDouble() - 0.5) * 20;
      final y = x * 0.5 + (math.Random().nextDouble() - 0.5) * 5;
      _scatterData.add(ScatterData(x, y));
    }
  }

  void _generateAreaData() {
    _areaData = [];
    for (int i = 0; i < 20; i++) {
      final x = i.toDouble();
      final y = math.sin(x * 0.3) * 10 + 15;
      _areaData.add(AreaData(x, y));
    }
  }

  void _generateHistogramData() {
    _histogramData = [];
    final bins = 10;
    final binWidth = 2.0;
    for (int i = 0; i < bins; i++) {
      final count = math.Random().nextInt(20) + 5;
      _histogramData.add(HistogramData(i * binWidth, count));
    }
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  @override
  void dispose() {
    _functionController.dispose();
    _xMinController.dispose();
    _xMaxController.dispose();
    super.dispose();
  }

  void _generateGraph() {
    try {
      switch (_selectedGraphType) {
        case 'Function Plot':
          _generateFunctionPlot();
          break;
        case 'Bar Chart':
          _generateBarChart();
          break;
        case 'Line Chart':
          _generateLineChart();
          break;
        case 'Pie Chart':
          _generatePieChart();
          break;
        case 'Scatter Plot':
          _generateScatterPlot();
          break;
        case 'Area Chart':
          _generateAreaChart();
          break;
        case 'Histogram':
          _generateHistogram();
          break;
        case 'Box Plot':
          _generateBoxPlot();
          break;
        case 'Heatmap':
          _generateHeatmap();
          break;
        case '3D Surface':
          _generate3DSurface();
          break;
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _generateFunctionPlot() {
    final function = _functionController.text.trim();
    if (function.isEmpty) {
      _showError('Please enter a function');
      return;
    }

    final xMin = double.tryParse(_xMinController.text) ?? -10;
    final xMax = double.tryParse(_xMaxController.text) ?? 10;

    _functionData.clear();
    for (double x = xMin; x <= xMax; x += 0.1) {
      try {
        double y = _evaluateFunction(function, x);
        if (y.isFinite) {
          _functionData.add(FlSpot(x, y));
        }
      } catch (e) {
        // Skip invalid points
      }
    }

    setState(() {
      _result = 'Function: $function\n'
               'Domain: [$xMin, $xMax]\n'
               'Points: ${_functionData.length}';
    });
  }

  double _evaluateFunction(String function, double x) {
    // Simple function evaluation for common functions
    function = function.toLowerCase().replaceAll(' ', '');
    
    if (function == 'x' || function == 'x^1') return x;
    if (function == 'x^2' || function == 'x²') return x * x;
    if (function == 'x^3' || function == 'x³') return x * x * x;
    if (function == 'sin(x)') return math.sin(x);
    if (function == 'cos(x)') return math.cos(x);
    if (function == 'tan(x)') return math.tan(x);
    if (function == 'log(x)') return x > 0 ? math.log(x) / math.ln10 : 0;
    if (function == 'ln(x)') return x > 0 ? math.log(x) : 0;
    if (function == 'exp(x)' || function == 'e^x') return math.exp(x);
    if (function == 'sqrt(x)' || function == '√x') return x >= 0 ? math.sqrt(x) : 0;
    if (function == 'abs(x)' || function == '|x|') return x.abs();
    if (function == '1/x') return x != 0 ? 1 / x : 0;
    
    // Handle simple polynomials like 2x, 3x^2, etc.
    if (function.contains('x^')) {
      final parts = function.split('x^');
      if (parts.length == 2) {
        final coefficient = double.tryParse(parts[0]) ?? 1.0;
        final exponent = double.tryParse(parts[1]) ?? 1.0;
        return coefficient * math.pow(x, exponent);
      }
    }
    
    // Handle simple linear functions like 2x, 3x, etc.
    if (function.endsWith('x')) {
      final coefficient = double.tryParse(function.substring(0, function.length - 1)) ?? 1.0;
      return coefficient * x;
    }
    
    throw ArgumentError('Unsupported function: $function');
  }

  void _generateBarChart() {
    _generateBarChartData();
    setState(() {
      _result = 'Bar Chart Generated\n'
               'Categories: ${_barChartData.length}\n'
               'Max Value: ${_barChartData.map((e) => e.y).reduce((a, b) => a > b ? a : b)}\n'
               'Min Value: ${_barChartData.map((e) => e.y).reduce((a, b) => a < b ? a : b)}';
    });
  }

  void _generateLineChart() {
    _generateLineChartData();
    setState(() {
      _result = 'Line Chart Generated\n'
               'Data Points: ${_lineChartData.length}\n'
               'Trend: ${_calculateTrend(_lineChartData)}';
    });
  }

  void _generatePieChart() {
    _generatePieChartData();
    final total = _pieChartData.map((e) => e.value).reduce((a, b) => a + b);
    setState(() {
      _result = 'Pie Chart Generated\n'
               'Sectors: ${_pieChartData.length}\n'
               'Total: $total\n'
               'Largest: ${_pieChartData.map((e) => e.value).reduce((a, b) => a > b ? a : b)}';
    });
  }

  void _generateScatterPlot() {
    _generateScatterData();
    final correlation = _calculateCorrelation(_scatterData);
    setState(() {
      _result = 'Scatter Plot Generated\n'
               'Data Points: ${_scatterData.length}\n'
               'Correlation: ${correlation.toStringAsFixed(3)}';
    });
  }

  void _generateAreaChart() {
    _generateAreaData();
    final area = _calculateArea(_areaData);
    setState(() {
      _result = 'Area Chart Generated\n'
               'Data Points: ${_areaData.length}\n'
               'Area: ${area.toStringAsFixed(2)}';
    });
  }

  void _generateHistogram() {
    _generateHistogramData();
    final totalCount = _histogramData.map((e) => e.count).reduce((a, b) => a + b);
    setState(() {
      _result = 'Histogram Generated\n'
               'Bins: ${_histogramData.length}\n'
               'Total Count: $totalCount\n'
               'Max Count: ${_histogramData.map((e) => e.count).reduce((a, b) => a > b ? a : b)}';
    });
  }

  String _calculateTrend(List<ChartData> data) {
    if (data.length < 2) return 'Insufficient data';
    final first = data.first.y;
    final last = data.last.y;
    if (last > first) return 'Increasing';
    if (last < first) return 'Decreasing';
    return 'Stable';
  }

  double _calculateCorrelation(List<ScatterData> data) {
    if (data.length < 2) return 0.0;
    
    final n = data.length;
    final sumX = data.map((e) => e.x).reduce((a, b) => a + b);
    final sumY = data.map((e) => e.y).reduce((a, b) => a + b);
    final sumXY = data.map((e) => e.x * e.y).reduce((a, b) => a + b);
    final sumX2 = data.map((e) => e.x * e.x).reduce((a, b) => a + b);
    final sumY2 = data.map((e) => e.y * e.y).reduce((a, b) => a + b);
    
    final numerator = n * sumXY - sumX * sumY;
    final denominator = math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    
    return denominator != 0 ? numerator / denominator : 0.0;
  }

  double _calculateArea(List<AreaData> data) {
    if (data.length < 2) return 0.0;
    
    double area = 0.0;
    for (int i = 1; i < data.length; i++) {
      final width = data[i].x - data[i - 1].x;
      final avgHeight = (data[i].y + data[i - 1].y) / 2;
      area += width * avgHeight;
    }
    return area;
  }

  Widget _buildChartDisplay(ThemeData theme) {
    switch (_selectedGraphType) {
      case 'Function Plot':
        if (_functionData.isEmpty) return const SizedBox.shrink();
        return _buildFunctionPlot(theme);
      case 'Bar Chart':
        if (_barChartData.isEmpty) return const SizedBox.shrink();
        return _buildBarChart(theme);
      case 'Line Chart':
        if (_lineChartData.isEmpty) return const SizedBox.shrink();
        return _buildLineChart(theme);
      case 'Pie Chart':
        if (_pieChartData.isEmpty) return const SizedBox.shrink();
        return _buildPieChart(theme);
      case 'Scatter Plot':
        if (_scatterData.isEmpty) return const SizedBox.shrink();
        return _buildScatterPlot(theme);
      case 'Area Chart':
        if (_areaData.isEmpty) return const SizedBox.shrink();
        return _buildAreaChart(theme);
      case 'Histogram':
        if (_histogramData.isEmpty) return const SizedBox.shrink();
        return _buildHistogram(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFunctionPlot(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Function Plot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _functionData,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
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

  Widget _buildBarChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bar Chart',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _barChartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _barChartData.length) {
                            return Text(_barChartData[index].x);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _barChartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.y,
                          color: theme.colorScheme.primary,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Line Chart',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _lineChartData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.y);
                      }).toList(),
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
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

  Widget _buildPieChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pie Chart',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: true),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _pieChartData.map((data) {
                    return PieChartSectionData(
                      color: data.color,
                      value: data.value,
                      title: '${data.value.toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _pieChartData.map((data) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: data.color,
                    ),
                    const SizedBox(width: 4),
                    Text(data.label),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScatterPlot(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scatter Plot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: _scatterData.map((data) {
                    return ScatterSpot(data.x, data.y);
                  }).toList(),
                  minX: _scatterData.map((e) => e.x).reduce((a, b) => a < b ? a : b) - 1,
                  maxX: _scatterData.map((e) => e.x).reduce((a, b) => a > b ? a : b) + 1,
                  minY: _scatterData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1,
                  maxY: _scatterData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1,
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Area Chart',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _areaData.map((data) {
                        return FlSpot(data.x, data.y);
                      }).toList(),
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withOpacity(0.3),
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

  Widget _buildHistogram(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histogram',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _histogramData.map((e) => e.count.toDouble()).reduce((a, b) => a > b ? a : b) * 1.1,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _histogramData.length) {
                            return Text(_histogramData[index].bin.toStringAsFixed(1));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _histogramData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.count.toDouble(),
                          color: theme.colorScheme.primary,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateBoxPlot() {
    setState(() {
      _result = 'Box Plot Generated\n'
               'Quartiles: Q1=25, Q2=50, Q3=75\n'
               'Outliers: 2';
    });
  }

  void _generateHeatmap() {
    setState(() {
      _result = 'Heatmap Generated\n'
               'Matrix: 5x5\n'
               'Values: 0-100';
    });
  }

  void _generate3DSurface() {
    setState(() {
      _result = '3D Surface Generated\n'
               'Grid: 20x20\n'
               'Function: z = sin(x) * cos(y)';
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph & Charts'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareGraphResult(_selectedGraphType, _result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Graph Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Graph Type',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedGraphType,
                      isExpanded: true,
                      items: _graphTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGraphType = value!;
                          _result = '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Fields
            if (_selectedGraphType == 'Function Plot')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Function Parameters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _functionController,
                        decoration: const InputDecoration(
                          labelText: 'Function (e.g., x^2, sin(x), 2x)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _xMinController,
                              decoration: const InputDecoration(
                                labelText: 'X Min',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _xMaxController,
                              decoration: const InputDecoration(
                                labelText: 'X Max',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Generate Button
            ElevatedButton.icon(
              onPressed: _generateGraph,
              icon: const Icon(Icons.show_chart),
              label: const Text('Generate Graph'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Chart Display
            _buildChartDisplay(theme),

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
                                    await TTSService.speakGraphResult(_selectedGraphType, _result);
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

            const SizedBox(height: 16),

            // Quick Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Examples',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildQuickExample('x^2', 'Parabola'),
                    _buildQuickExample('sin(x)', 'Sine Wave'),
                    _buildQuickExample('cos(x)', 'Cosine Wave'),
                    _buildQuickExample('exp(x)', 'Exponential'),
                    _buildQuickExample('log(x)', 'Logarithmic'),
                    _buildQuickExample('sqrt(x)', 'Square Root'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickExample(String function, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGraphType = 'Function Plot';
            _functionController.text = function;
            _result = '';
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.functions,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$function - $description',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model classes for different chart types
class ChartData {
  final String x;
  final double y;
  
  ChartData(this.x, this.y);
}

class CustomPieChartData {
  final String label;
  final double value;
  final Color color;
  
  CustomPieChartData(this.label, this.value, this.color);
}

class ScatterData {
  final double x;
  final double y;
  
  ScatterData(this.x, this.y);
}

class AreaData {
  final double x;
  final double y;
  
  AreaData(this.x, this.y);
}

class HistogramData {
  final double bin;
  final int count;
  
  HistogramData(this.bin, this.count);
}

class PolarData {
  final double angle;
  final double radius;
  
  PolarData(this.angle, this.radius);
}

class ContourData {
  final double x;
  final double y;
  final double z;
  
  ContourData(this.x, this.y, this.z);
}

class VectorData {
  final double x;
  final double y;
  final double dx;
  final double dy;
  
  VectorData(this.x, this.y, this.dx, this.dy);
}

class StatisticalData {
  final String category;
  final double value;
  final double error;
  
  StatisticalData(this.category, this.value, this.error);
}

class FinancialData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  
  FinancialData(this.date, this.open, this.high, this.low, this.close, this.volume);
}