import 'package:flutter/material.dart';



import '../models/component_note.dart';

import '../models/component_page_meta_data.dart';

import '../models/variant_status.dart';

import '../widgets/component_page_scaffold.dart';

import '../widgets/pep_text_field.dart';

import '../widgets/variant_matrix_table.dart';



/// PEP text fields — uses [PepInputDecorationTheme] from app theme extensions.

class TextFieldsComponentPage extends StatefulWidget {

  const TextFieldsComponentPage({super.key});



  static const meta = ComponentPageMetaData(

    id: 'text_fields',

    title: 'Text fields',

    m3SpecUrl: 'https://m3.material.io/components/text-fields/specs',

    description:

        'PEP outlined text fields with external label, surface fill, and full outline. '

        'Decoration tokens live in PepInputDecorationTheme on ThemeData.extensions.',

  );



  @override

  State<TextFieldsComponentPage> createState() => _TextFieldsComponentPageState();

}



class _TextFieldsComponentPageState extends State<TextFieldsComponentPage> {

  bool _showLeadingIcon = false;

  bool _showTrailingIcon = false;

  bool _showHelperText = true;

  final _pepOutlinedController = TextEditingController();

  final _pepOutlinedPlainController = TextEditingController();



  static const _statuses = [

    VariantStaticStatus.enabled,

    VariantStaticStatus.disabled,

    VariantStaticStatus.error,

  ];



  @override

  void dispose() {

    _pepOutlinedController.dispose();

    _pepOutlinedPlainController.dispose();

    super.dispose();

  }



  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'PepInputDecorationTheme',
      spec:
          'On ThemeData.extensions (PepThemeExtension). Filled '
          'surfaceContainerLowest; outline 4dp radius; minHeight 56; '
          'pad 16; focused primary 2dp.',
      setupCode: '''
// Via PepThemeExtension.from(colorScheme) in AppTheme
PepTextField(
  label: 'Label',
  hintText: 'Hint',
  helperText: 'Helper',
)
PepTextField(
  showExternalLabel: false,
  hintText: 'Hint only',
)
''',
    ),
  ];



  static const _rows = <VariantMatrixRow>[

    VariantMatrixRow(

      id: 'pep_outlined',

      label: 'PEP outlined',

      supportsLeadingIcon: true,

      supportsTrailingIcon: true,

    ),

    VariantMatrixRow(

      id: 'pep_outlined_no_label',

      label: 'PEP outlined · no label',

      supportsLeadingIcon: true,

      supportsTrailingIcon: true,

    ),

  ];



  @override

  Widget build(BuildContext context) {

    return ComponentPageScaffold(

      title: TextFieldsComponentPage.meta.title,

      m3SpecUrl: TextFieldsComponentPage.meta.m3SpecUrl,

      description: TextFieldsComponentPage.meta.description,

      notes: _notes,

      pendingVariants: const [],

      variantsSection: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          VariantIconControls(

            showLeadingIcon: _showLeadingIcon,

            showTrailingIcon: _showTrailingIcon,

            showHelperText: _showHelperText,

            leadingLabel: 'Leading icon',

            trailingLabel: 'Trailing icon',

            onLeadingChanged: (v) => setState(() => _showLeadingIcon = v),

            onTrailingChanged: (v) => setState(() => _showTrailingIcon = v),

            onHelperTextChanged: (v) => setState(() => _showHelperText = v),

          ),

          const SizedBox(height: 12),

          VariantMatrixTable(

            rows: _rows,

            statuses: _statuses,

            showLeadingIcon: _showLeadingIcon,

            showTrailingIcon: _showTrailingIcon,

            showHelperText: _showHelperText,

            selectionState: const {},

            cellBuilder: _buildCell,

          ),

        ],

      ),

    );

  }



  Widget _buildCell(

    BuildContext context,

    VariantMatrixRow row,

    VariantMatrixCell cell,

  ) {

    final controller = row.id == 'pep_outlined'

        ? _pepOutlinedController

        : _pepOutlinedPlainController;



    return PepTextField(

      label: 'Label',

      showExternalLabel: row.id == 'pep_outlined',

      controller: controller,

      enabled: cell.isEnabled,

      showHelperText: cell.showHelperText,

      status: cell.isError ? PepTextFieldStatus.error : PepTextFieldStatus.normal,

      prefixIcon:

          cell.showLeadingIcon ? const Icon(Icons.person_outline) : null,

      suffixIcon: cell.showTrailingIcon ? const Icon(Icons.close) : null,

    );

  }

}


