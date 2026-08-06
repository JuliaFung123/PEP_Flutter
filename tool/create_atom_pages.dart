#!/usr/bin/env dart
// Lists all M3 atom component pages in this project.
//
// Usage: dart run tool/create_atom_pages.dart

void main() {
  const atoms = <(String, String, String)>[
    ('app_bars', 'App bars', 'https://m3.material.io/components/app-bars/specs'),
    ('badges', 'Badges', 'https://m3.material.io/components/badges/specs'),
    ('buttons', 'Buttons', 'https://m3.material.io/components/buttons/specs'),
    ('checkbox', 'Checkbox', 'https://m3.material.io/components/checkbox/specs'),
    ('chips', 'Chips', 'https://m3.material.io/components/chips/specs'),
    ('divider', 'Divider', 'https://m3.material.io/components/divider/specs'),
    (
      'progress_indicators',
      'Progress indicators',
      'https://m3.material.io/components/progress-indicators/specs',
    ),
    (
      'radio_button',
      'Radio button',
      'https://m3.material.io/components/radio-button/specs',
    ),
    ('sliders', 'Sliders', 'https://m3.material.io/components/sliders/specs'),
    ('switch', 'Switch', 'https://m3.material.io/components/switch/specs'),
    (
      'text_fields',
      'Text fields',
      'https://m3.material.io/components/text-fields/specs',
    ),
    (
      'typography',
      'Typography',
      'https://m3.material.io/styles/typography/overview',
    ),
  ];

  print('M3 atom pages (${atoms.length}):');
  for (final (id, title, url) in atoms) {
    print('  - $title ($id): $url');
  }
  print('');
  print('Scaffold a new page:');
  print(
    '  dart run tool/create_component_page.dart <id> "<title>" "<m3_spec_url>"',
  );
}
