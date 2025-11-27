import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_gradients.dart';
import 'package:flutter_application_1/core/widgets/app_button.dart';
import 'package:flutter_application_1/core/widgets/app_outlined_button.dart';
import 'package:flutter_application_1/core/widgets/app_text_field.dart';
import 'package:flutter_application_1/core/widgets/app_radio_option.dart';
import 'package:flutter_application_1/core/widgets/result_card.dart';
import 'package:flutter_application_1/core/widgets/section_title.dart';
import 'package:flutter_application_1/features/salary_calculator/constants/salary_strings.dart';
import 'package:flutter_application_1/features/salary_calculator/presentation/providers/salary_calculator_provider.dart';
import 'package:intl/intl.dart';

class SalaryCalculatorPageRefactored extends ConsumerStatefulWidget {
  const SalaryCalculatorPageRefactored({super.key});

  @override
  ConsumerState<SalaryCalculatorPageRefactored> createState() => _SalaryCalculatorPageRefactoredState();
}

class _SalaryCalculatorPageRefactoredState extends ConsumerState<SalaryCalculatorPageRefactored> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _dependentsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _selectedRegulation = 'new';
  String _selectedInsurance = 'on_salary';
  int _selectedRegion = 1;
  bool _isGrossToNet = true;
  
  Map<String, double>? _result;

  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void dispose() {
    _salaryController.dispose();
    _dependentsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _calculate() {
    final salaryText = _salaryController.text.trim();
    
    if (salaryText.isEmpty) {
      _showSnackBar(SalaryStrings.enterIncome, Colors.orange);
      return;
    }
    
    final salary = double.tryParse(salaryText);
    
    if (salary == null || salary <= 0) {
      _showSnackBar(SalaryStrings.incomeGreaterThanZero, Colors.red);
      return;
    }

    final dependents = int.tryParse(_dependentsController.text) ?? 0;

    setState(() {
      if (_isGrossToNet) {
        final useCase = ref.read(calculateGrossToNetProvider);
        final result = useCase(grossSalary: salary, dependents: dependents);
        _result = result.toMap();
        _result!['taxBreakdown'] = result.taxBreakdown.values.reduce((a, b) => a + b);
      } else {
        final useCase = ref.read(calculateNetToGrossProvider);
        final result = useCase(netSalary: salary, dependents: dependents);
        _result = result.toMap();
        _result!['taxBreakdown'] = result.taxBreakdown.values.reduce((a, b) => a + b);
      }
    });

    _showSnackBar(
      '${SalaryStrings.calculationSuccess} NET: ${_currencyFormat.format(_result!['net'])} VNĐ',
      Colors.green,
    );

    _scrollToResults();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  void _scrollToResults() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          SalaryStrings.pageTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRegulationSection(),
            const SizedBox(height: 24),
            _buildIncomeSection(),
            const SizedBox(height: 24),
            _buildInsuranceSection(),
            const SizedBox(height: 24),
            _buildRegionSection(),
            const SizedBox(height: 24),
            _buildDependentsSection(),
            const SizedBox(height: 24),
            if (_result != null) ...[
              _buildResults(),
              const SizedBox(height: 100),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildRegulationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: SalaryStrings.regulationTitle),
        const SizedBox(height: 12),
        AppRadioOption<String>(
          label: SalaryStrings.newRegulation,
          value: 'new',
          groupValue: _selectedRegulation,
          onChanged: (value) => setState(() => _selectedRegulation = value),
        ),
        const SizedBox(height: 8),
        AppRadioOption<String>(
          label: SalaryStrings.oldRegulation,
          value: 'old',
          groupValue: _selectedRegulation,
          onChanged: (value) => setState(() => _selectedRegulation = value),
        ),
      ],
    );
  }

  Widget _buildIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: SalaryStrings.incomeTitle),
        const SizedBox(height: 12),
        AppTextField(
          controller: _salaryController,
          hintText: SalaryStrings.salaryPlaceholder,
          helperText: SalaryStrings.salaryHint,
          suffixText: SalaryStrings.currency,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: SalaryStrings.insuranceTitle),
        const SizedBox(height: 12),
        AppRadioOption<String>(
          label: SalaryStrings.insuranceOnSalary,
          value: 'on_salary',
          groupValue: _selectedInsurance,
          onChanged: (value) => setState(() => _selectedInsurance = value),
        ),
        const SizedBox(height: 8),
        AppRadioOption<String>(
          label: SalaryStrings.insuranceOther,
          value: 'other',
          groupValue: _selectedInsurance,
          onChanged: (value) => setState(() => _selectedInsurance = value),
        ),
      ],
    );
  }

  Widget _buildRegionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: SalaryStrings.regionTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppRadioOption<int>(
                label: SalaryStrings.regionI,
                value: 1,
                groupValue: _selectedRegion,
                onChanged: (value) => setState(() => _selectedRegion = value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppRadioOption<int>(
                label: SalaryStrings.regionII,
                value: 2,
                groupValue: _selectedRegion,
                onChanged: (value) => setState(() => _selectedRegion = value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppRadioOption<int>(
                label: SalaryStrings.regionIII,
                value: 3,
                groupValue: _selectedRegion,
                onChanged: (value) => setState(() => _selectedRegion = value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppRadioOption<int>(
                label: SalaryStrings.regionIV,
                value: 4,
                groupValue: _selectedRegion,
                onChanged: (value) => setState(() => _selectedRegion = value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDependentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: SalaryStrings.dependentsTitle),
        const SizedBox(height: 12),
        AppTextField(
          controller: _dependentsController,
          hintText: SalaryStrings.dependentsPlaceholder,
          suffixText: SalaryStrings.dependentsUnit,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_result == null) return const SizedBox.shrink();

    return Column(
      children: [
        ResultCard(
          title: SalaryStrings.detailBreakdown,
          rows: [
            ResultRow(label: SalaryStrings.grossSalary, value: _result!['gross']!, isHighlight: true),
            ResultRow(label: SalaryStrings.socialInsurance, value: -_result!['socialInsurance']!),
            ResultRow(label: SalaryStrings.healthInsurance, value: -_result!['healthInsurance']!),
            ResultRow(label: SalaryStrings.unemploymentInsurance, value: -_result!['unemploymentInsurance']!),
            ResultRow(label: SalaryStrings.incomeBeforeTax, value: _result!['incomeBeforeTax']!, showDivider: true),
            ResultRow(label: SalaryStrings.personalDeduction, value: -_result!['personalDeduction']!),
            ResultRow(label: SalaryStrings.dependentDeduction, value: -_result!['dependentDeduction']!),
            ResultRow(label: SalaryStrings.taxableIncome, value: _result!['taxableIncome']!, showDivider: true),
            ResultRow(label: SalaryStrings.personalIncomeTax, value: -_result!['personalIncomeTax']!),
            ResultRow(label: SalaryStrings.netSalary, value: _result!['net']!, isHighlight: true, color: const Color(0xFF10B981), showDivider: true),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8F9FA).withOpacity(0.95),
            Colors.white.withOpacity(0.98),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  text: SalaryStrings.netToGross,
                  onPressed: () {
                    setState(() => _isGrossToNet = false);
                    _calculate();
                  },
                  borderColor: const Color(0xFF10B981),
                  textColor: const Color(0xFF10B981),
                  icon: Icons.arrow_back,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  text: SalaryStrings.grossToNet,
                  onPressed: () {
                    setState(() => _isGrossToNet = true);
                    _calculate();
                  },
                  gradient: AppGradients.success,
                  icon: Icons.arrow_forward,
                  iconAfterText: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
