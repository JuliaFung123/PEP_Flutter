import 'package:flutter/material.dart';



import '../models/component_note.dart';

import '../models/component_page_meta_data.dart';

import '../models/variant_status.dart';

import '../widgets/component_page_scaffold.dart';

import '../widgets/kpi_text_field.dart';

import '../widgets/variant_matrix_table.dart';



/// KPI text fields — uses [KpiInputDecorationTheme] from app theme extensions.

class TextFieldsComponentPage extends StatefulWidget {

  const TextFieldsComponentPage({super.key});



  static const meta = ComponentPageMetaData(

    id: 'text_fields',

    title: 'Text fields',

    m3SpecUrl: 'https://m3.material.io/components/text-fields/specs',

    description:

        'KPI outlined text fields with external label, surface fill, and full outline. '

        'Decoration tokens live in KpiInputDecorationTheme on ThemeData.extensions.',

  );



  @override

  State<TextFieldsComponentPage> createState() => _TextFieldsComponentPageState();

}



class _TextFieldsComponentPageState extends State<TextFieldsComponentPage> {

  bool _showLeadingIcon = false;

  bool _showTrailingIcon = false;

  bool _showHelperText = true;

  final _kpiOutlinedController = TextEditingController();

  final _kpiOutlinedPlainController = TextEditingController();



  static const _statuses = [

    VariantStaticStatus.enabled,

    VariantStaticStatus.disabled,

    VariantStaticStatus.error,

  ];



  @override

  void dispose() {

    _kpiOutlinedController.dispose();

    _kpiOutlinedPlainController.dispose();

    super.dispose();

  }



  static const _notes = <ComponentNote>[

    ComponentNote(

      variant: 'KPI theme',

      m3Behavior: 'Custom outlined field — not M3 filled or outlined.',

      ourImplementation:

          'KpiInputDecorationTheme on ThemeData.extensions — portable across projects.',

      action: 'Use theme + KpiTextField',

    ),

    ComponentNote(

      variant: 'KPI outlined',

      m3Behavior:

          'Surface fill plus full outline; external label above the field.',

      ourImplementation:

          'KpiTextField — inherits decoration via applyDefaults(kpiInputDecorationTheme).',

      action: 'Use as-is',

    ),

    ComponentNote(

      variant: 'KPI outlined · no label',

      m3Behavior:

          'Outlined field without external label; hint and helper text only.',

      ourImplementation:

          'KpiTextField with showExternalLabel: false — helper text kept.',

      action: 'Use as-is',

    ),

    ComponentNote(

      variant: 'Helper text',

      m3Behavior:

          'Optional helper below the field on enabled/disabled states; toggled via API.',

      ourImplementation:

          'Helper text switch sets helperText — omitted on the error column (M3).',

      action: 'Use as-is',

    ),

    ComponentNote(

      variant: 'Error text',

      m3Behavior:

          'Replaces helper text in the subtext slot when the field is in error.',

      ourImplementation:

          'errorText on error column only — standard InputDecoration behavior.',

      action: 'Use as-is',

    ),

  ];



  static const _rows = <VariantMatrixRow>[

    VariantMatrixRow(

      id: 'kpi_outlined',

      label: 'KPI outlined',

      supportsLeadingIcon: true,

      supportsTrailingIcon: true,

    ),

    VariantMatrixRow(

      id: 'kpi_outlined_no_label',

      label: 'KPI outlined · no label',

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

    final controller = row.id == 'kpi_outlined'

        ? _kpiOutlinedController

        : _kpiOutlinedPlainController;



    return KpiTextField(

      label: 'Label',

      showExternalLabel: row.id == 'kpi_outlined',

      controller: controller,

      enabled: cell.isEnabled,

      showHelperText: cell.showHelperText,

      status: cell.isError ? KpiTextFieldStatus.error : KpiTextFieldStatus.normal,

      prefixIcon:

          cell.showLeadingIcon ? const Icon(Icons.person_outline) : null,

      suffixIcon: cell.showTrailingIcon ? const Icon(Icons.close) : null,

    );

  }

}


