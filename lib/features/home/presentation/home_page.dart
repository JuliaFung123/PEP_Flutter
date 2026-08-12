import 'package:flutter/material.dart';

import '../../../component_library/widgets/pep_button_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('PEP Flutter', style: textTheme.titleLarge),
        actions: [
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              tooltip: 'Settings',
              onPressed: () {},
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                maximumSize: const Size(48, 48),
                fixedSize: const Size(48, 48),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.standard,
              ),
              icon: const Icon(Icons.settings_outlined, size: 24),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Material 3 ready',
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Flutter environment is configured with dynamic color, '
                    'light/dark themes, and M3 components.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Components', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: _incrementCounter,
                style: PepButtonStyles.labelStyle(context, PepButtonSize.s40),
                child: const Text('Filled'),
              ),
              OutlinedButton(
                onPressed: _incrementCounter,
                style: PepButtonStyles.labelStyle(context, PepButtonSize.s40),
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: _incrementCounter,
                style: PepButtonStyles.labelStyle(context, PepButtonSize.s40),
                child: const Text('Text'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                child: const Icon(Icons.trending_up),
              ),
              title: Text('Counter', style: textTheme.titleMedium),
              subtitle: Text('Taps: $_counter', style: textTheme.bodySmall),
              trailing: IconButton.filledTonal(
                onPressed: _incrementCounter,
                style: PepButtonStyles.iconStyle(PepButtonSize.s40),
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        icon: const Icon(Icons.add),
        label: const Text('Increment'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() => _counter++);
  }
}
