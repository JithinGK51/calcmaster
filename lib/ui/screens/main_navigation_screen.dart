import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator_screen.dart';
import 'scientific_calculator_screen.dart';
import 'algebra_screen.dart';
import 'geometry_screen.dart';
import 'finance_screen.dart';
import 'health_screen.dart';
import 'unit_converter_screen.dart';
import 'currency_converter_screen.dart';
import 'graph_screen.dart';
import 'budget_screen.dart';
import 'reminder_screen.dart';
import 'privacy_vault_screen.dart';
import 'history_screen.dart';
import 'stats_insights_screen.dart';
import 'performance_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const CalculatorScreen(),
    const AlgebraScreen(),
    const GeometryScreen(),
    const FinanceScreen(),
    const HealthScreen(),
  ];

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.calculate_outlined),
      selectedIcon: Icon(Icons.calculate),
      label: 'Calculator',
    ),
    const NavigationDestination(
      icon: Icon(Icons.functions_outlined),
      selectedIcon: Icon(Icons.functions),
      label: 'Algebra',
    ),
    const NavigationDestination(
      icon: Icon(Icons.shape_line_outlined),
      selectedIcon: Icon(Icons.shape_line),
      label: 'Geometry',
    ),
    const NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: 'Finance',
    ),
    const NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Health',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        _destinations[_currentIndex].label,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.calculate_rounded,
                  size: 48,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  'CalcMaster',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ultimate Calculator Hub',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.calculate_outlined,
                  title: 'Calculator',
                  onTap: () => _navigateToScreen(0),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.science_outlined,
                  title: 'Scientific Calculator',
                  onTap: () => _navigateToScientificCalculator(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.functions_outlined,
                  title: 'Algebra Solver',
                  onTap: () => _navigateToScreen(1),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shape_line_outlined,
                  title: 'Geometry',
                  onTap: () => _navigateToScreen(2),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Finance',
                  onTap: () => _navigateToScreen(3),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.favorite_outline,
                  title: 'Health',
                  onTap: () => _navigateToScreen(4),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.swap_horiz_outlined,
                  title: 'Unit Converter',
                  onTap: () => _navigateToScreenWidget(const UnitConverterScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.currency_exchange_outlined,
                  title: 'Currency Converter',
                  onTap: () => _navigateToScreenWidget(const CurrencyConverterScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.show_chart_outlined,
                  title: 'Graphs & Charts',
                  onTap: () => _navigateToScreenWidget(const GraphScreen()),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_outlined,
                  title: 'Budget Manager',
                  onTap: () => _navigateToScreenWidget(const BudgetScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.alarm_outlined,
                  title: 'Reminders',
                  onTap: () => _navigateToScreenWidget(const ReminderScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Privacy Vault',
                  onTap: () => _navigateToScreenWidget(const PrivacyVaultScreen()),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Statistics & Insights',
                  onTap: () => _navigateToScreenWidget(const StatsInsightsScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.speed_outlined,
                  title: 'Performance Monitor',
                  onTap: () => _navigateToScreenWidget(const PerformanceScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _navigateToScreenWidget(const SettingsScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => _navigateToScreenWidget(const AboutScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  void _navigateToScreenWidget(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _navigateToScientificCalculator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScientificCalculatorScreen(),
      ),
    );
  }
}
