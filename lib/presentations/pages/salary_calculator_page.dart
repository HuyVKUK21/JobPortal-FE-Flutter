import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class SalaryCalculatorPage extends StatefulWidget {
  const SalaryCalculatorPage({super.key});

  @override
  State<SalaryCalculatorPage> createState() => _SalaryCalculatorPageState();
}

class _SalaryCalculatorPageState extends State<SalaryCalculatorPage> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _dependentsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _selectedRegulation = 'new'; // 'new' or 'old'
  String _selectedInsurance = 'on_salary'; // 'on_salary' or 'other'
  int _selectedRegion = 1; // 1, 2, 3, 4
  int _dependents = 0;
  bool _isGrossToNet = true; // true = Gross->Net, false = Net->Gross
  
  Map<String, double> _result = {};

  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void dispose() {
    _salaryController.dispose();
    _dependentsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _calculate() {
    // Get raw text (digits only now)
    final salaryText = _salaryController.text.trim();
    print('=== CALCULATE START ===');
    print('Raw salary text: "$salaryText"');
    
    if (salaryText.isEmpty) {
      print('ERROR: Salary is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập thu nhập'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final salary = double.tryParse(salaryText);
    print('Parsed salary: $salary');
    
    if (salary == null || salary <= 0) {
      print('ERROR: Salary is null or zero: $salary');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thu nhập phải lớn hơn 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('SUCCESS: Valid salary: $salary');
    print('Calculating... isGrossToNet: $_isGrossToNet');
    
    setState(() {
      if (_isGrossToNet) {
        _result = _calculateGrossToNet(salary);
      } else {
        _result = _calculateNetToGross(salary);
      }
      print('Result keys: ${_result.keys}');
      print('GROSS: ${_result['gross']}');
      print('NET: ${_result['net']}');
      print('=== CALCULATE END ===');
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tính toán thành công! NET: ${_currencyFormat.format(_result['net'])} VNĐ'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Scroll to results after a short delay
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

  Map<String, double> _calculateGrossToNet(double grossSalary) {
    // Bảo hiểm
    double socialInsurance = grossSalary * 0.08;
    double healthInsurance = grossSalary * 0.015;
    double unemploymentInsurance = grossSalary * 0.01;
    double totalInsurance = socialInsurance + healthInsurance + unemploymentInsurance;
    
    // Thu nhập trước thuế
    double incomeBeforeTax = grossSalary - totalInsurance;
    
    // Giảm trừ
    double personalDeduction = 11000000;
    double dependentDeduction = _dependents * 4400000;
    double totalDeduction = personalDeduction + dependentDeduction;
    
    // Thu nhập chịu thuế
    double taxableIncome = incomeBeforeTax - totalDeduction;
    
    // Tính thuế TNCN
    double personalIncomeTax = _calculatePersonalIncomeTax(taxableIncome);
    
    // Lương NET
    double netSalary = incomeBeforeTax - personalIncomeTax;
    
    return {
      'gross': grossSalary,
      'socialInsurance': socialInsurance,
      'healthInsurance': healthInsurance,
      'unemploymentInsurance': unemploymentInsurance,
      'totalInsurance': totalInsurance,
      'incomeBeforeTax': incomeBeforeTax,
      'personalDeduction': personalDeduction,
      'dependentDeduction': dependentDeduction,
      'taxableIncome': taxableIncome > 0 ? taxableIncome : 0,
      'personalIncomeTax': personalIncomeTax,
      'net': netSalary,
    };
  }

  Map<String, double> _calculateNetToGross(double netSalary) {
    // Tính ngược từ NET sang GROSS (simplified)
    double estimatedGross = netSalary * 1.2; // Ước tính ban đầu
    
    // Iterate để tìm GROSS chính xác
    for (int i = 0; i < 10; i++) {
      var result = _calculateGrossToNet(estimatedGross);
      double calculatedNet = result['net']!;
      double diff = netSalary - calculatedNet;
      
      if (diff.abs() < 1000) break;
      estimatedGross += diff;
    }
    
    return _calculateGrossToNet(estimatedGross);
  }

  double _calculatePersonalIncomeTax(double taxableIncome) {
    if (taxableIncome <= 0) return 0;
    
    double tax = 0;
    
    if (taxableIncome <= 5000000) {
      tax = taxableIncome * 0.05;
    } else if (taxableIncome <= 10000000) {
      tax = 5000000 * 0.05 + (taxableIncome - 5000000) * 0.10;
    } else if (taxableIncome <= 18000000) {
      tax = 5000000 * 0.05 + 5000000 * 0.10 + (taxableIncome - 10000000) * 0.15;
    } else if (taxableIncome <= 32000000) {
      tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + (taxableIncome - 18000000) * 0.20;
    } else if (taxableIncome <= 52000000) {
      tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + 14000000 * 0.20 + (taxableIncome - 32000000) * 0.25;
    } else if (taxableIncome <= 80000000) {
      tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + 14000000 * 0.20 + 20000000 * 0.25 + (taxableIncome - 52000000) * 0.30;
    } else {
      tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + 14000000 * 0.20 + 20000000 * 0.25 + 28000000 * 0.30 + (taxableIncome - 80000000) * 0.35;
    }
    
    return tax;
  }

  Map<String, double> _calculateTaxBreakdown(double taxableIncome) {
    if (taxableIncome <= 0) {
      return {
        'bracket1': 0, 'bracket2': 0, 'bracket3': 0, 'bracket4': 0,
        'bracket5': 0, 'bracket6': 0, 'bracket7': 0,
      };
    }

    double bracket1 = 0, bracket2 = 0, bracket3 = 0, bracket4 = 0;
    double bracket5 = 0, bracket6 = 0, bracket7 = 0;

    if (taxableIncome > 0) bracket1 = (taxableIncome > 5000000 ? 5000000 : taxableIncome) * 0.05;
    if (taxableIncome > 5000000) bracket2 = (taxableIncome > 10000000 ? 5000000 : taxableIncome - 5000000) * 0.10;
    if (taxableIncome > 10000000) bracket3 = (taxableIncome > 18000000 ? 8000000 : taxableIncome - 10000000) * 0.15;
    if (taxableIncome > 18000000) bracket4 = (taxableIncome > 32000000 ? 14000000 : taxableIncome - 18000000) * 0.20;
    if (taxableIncome > 32000000) bracket5 = (taxableIncome > 52000000 ? 20000000 : taxableIncome - 32000000) * 0.25;
    if (taxableIncome > 52000000) bracket6 = (taxableIncome > 80000000 ? 28000000 : taxableIncome - 52000000) * 0.30;
    if (taxableIncome > 80000000) bracket7 = (taxableIncome - 80000000) * 0.35;

    return {
      'bracket1': bracket1,
      'bracket2': bracket2,
      'bracket3': bracket3,
      'bracket4': bracket4,
      'bracket5': bracket5,
      'bracket6': bracket6,
      'bracket7': bracket7,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'Tính lương Gross - Net',
          style: TextStyle(
            fontSize: 18,
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
            // Regulation Selection
            _buildSectionTitle('Áp dụng quy định'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    'Từ 01/07/2022 (Quy định mới)',
                    _selectedRegulation == 'new',
                    () => setState(() => _selectedRegulation = 'new'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    'Từ 01/07/2020 - 30/06/2022',
                    _selectedRegulation == 'old',
                    () => setState(() => _selectedRegulation = 'old'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Salary Input
            _buildSectionTitle('Thu nhập'),
            const SizedBox(height: 12),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: '10000000',
                suffixText: '(VNĐ)',
                helperText: 'Nhập số không có dấu phẩy',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderLight.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderLight.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Insurance Selection
            _buildSectionTitle('Đóng bảo hiểm'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    'Trên mức lương chính thức',
                    _selectedInsurance == 'on_salary',
                    () => setState(() => _selectedInsurance = 'on_salary'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRadioOption(
                    'Khác',
                    _selectedInsurance == 'other',
                    () => setState(() => _selectedInsurance = 'other'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Region Selection
            _buildSectionTitle('Vùng (Giải thích)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildRadioOption('I', _selectedRegion == 1, () => setState(() => _selectedRegion = 1))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioOption('II', _selectedRegion == 2, () => setState(() => _selectedRegion = 2))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioOption('III', _selectedRegion == 3, () => setState(() => _selectedRegion = 3))),
                const SizedBox(width: 8),
                Expanded(child: _buildRadioOption('IV', _selectedRegion == 4, () => setState(() => _selectedRegion = 4))),
              ],
            ),
            const SizedBox(height: 24),

            // Dependents
            _buildSectionTitle('Số người phụ thuộc'),
            const SizedBox(height: 12),
            TextField(
              controller: _dependentsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  _dependents = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: '0',
                suffixText: '(Người)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderLight.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderLight.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Results
            if (_result.isNotEmpty) ...[
              _buildResultSection(),
              const SizedBox(height: 24),
            ],
            
            const SizedBox(height: 100), // Extra space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isGrossToNet = false;
                        });
                        _calculate();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(color: Color(0xFF10B981), width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: const Color(0xFF10B981),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Net → Gross',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isGrossToNet = true;
                        });
                        _calculate();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Gross → Net',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRadioOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : AppColors.borderLight.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF10B981) : AppColors.grey400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    final taxBreakdown = _calculateTaxBreakdown(_result['taxableIncome'] ?? 0);
    final grossSalary = _result['gross'] ?? 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Diễn giải chi tiết',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '(VNĐ)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildResultRow('Lương GROSS', _result['gross']!, isHighlight: true, color: const Color(0xFF10B981)),
              _buildResultRow('Bảo hiểm xã hội (8%)', -_result['socialInsurance']!),
              _buildResultRow('Bảo hiểm y tế (1.5%)', -_result['healthInsurance']!),
              _buildResultRow('Bảo hiểm thất nghiệp (1%)', -_result['unemploymentInsurance']!),
              _buildResultRow('Thu nhập trước thuế', _result['incomeBeforeTax']!),
              _buildResultRow('Giảm trừ gia cảnh bản thân', -_result['personalDeduction']!),
              _buildResultRow('Giảm trừ gia cảnh người phụ thuộc', -_result['dependentDeduction']!),
              _buildResultRow('Thu nhập chịu thuế', _result['taxableIncome']!),
              _buildResultRow('Thuế thu nhập cá nhân', -_result['personalIncomeTax']!),
              const Divider(height: 24),
              _buildResultRow('Lương NET', _result['net']!, isHighlight: true, color: const Color(0xFF10B981)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Tax Breakdown
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi tiết thuế TNCN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '(VNĐ)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildResultRow('Đến 5 triệu VNĐ (5%)', taxBreakdown['bracket1']!),
              _buildResultRow('Trên 5 triệu VNĐ đến 10 triệu VNĐ (10%)', taxBreakdown['bracket2']!),
              _buildResultRow('Trên 10 triệu VNĐ đến 18 triệu VNĐ (15%)', taxBreakdown['bracket3']!),
              _buildResultRow('Trên 18 triệu VNĐ đến 32 triệu VNĐ (20%)', taxBreakdown['bracket4']!),
              _buildResultRow('Trên 32 triệu VNĐ đến 52 triệu VNĐ (25%)', taxBreakdown['bracket5']!),
              _buildResultRow('Trên 52 triệu VNĐ đến 80 triệu VNĐ (30%)', taxBreakdown['bracket6']!),
              _buildResultRow('Trên 80 triệu VNĐ (35%)', taxBreakdown['bracket7']!),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Employer Contributions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Người sử dụng lao động trả',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '(VNĐ)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildResultRow('Lương GROSS', grossSalary, isHighlight: true, color: const Color(0xFF10B981)),
              _buildResultRow('Bảo hiểm xã hội (17%)', grossSalary * 0.17),
              _buildResultRow('Bảo hiểm tai nạn lao động - Bệnh nghề nghiệp (0.5%)', grossSalary * 0.005),
              _buildResultRow('Bảo hiểm y tế', grossSalary * 0.03),
              _buildResultRow('Bảo hiểm thất nghiệp', grossSalary * 0.01),
              const Divider(height: 24),
              _buildResultRow('Tổng cộng', grossSalary * 1.215, isHighlight: true, color: const Color(0xFF10B981)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, double value, {bool isHighlight = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHighlight ? 15 : 14,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                color: color ?? (isHighlight ? AppColors.textPrimary : AppColors.textSecondary),
              ),
            ),
          ),
          Text(
            _currencyFormat.format(value.abs()),
            style: TextStyle(
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
              color: color ?? (value < 0 ? Colors.red : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
