import 'package:flutter_application_1/features/salary_calculator/constants/salary_constants.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/entities/salary_result.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/repositories/salary_calculator_repository.dart';

class SalaryCalculatorRepositoryImpl implements SalaryCalculatorRepository {
  @override
  SalaryResult calculateGrossToNet({
    required double grossSalary,
    required int dependents,
  }) {
    // Calculate insurance
    final socialInsurance = grossSalary * SalaryConstants.socialInsuranceRate;
    final healthInsurance = grossSalary * SalaryConstants.healthInsuranceRate;
    final unemploymentInsurance = grossSalary * SalaryConstants.unemploymentInsuranceRate;
    final totalInsurance = socialInsurance + healthInsurance + unemploymentInsurance;

    // Income before tax
    final incomeBeforeTax = grossSalary - totalInsurance;

    // Deductions
    final personalDeduction = SalaryConstants.personalDeduction;
    final dependentDeduction = dependents * SalaryConstants.dependentDeduction;

    // Taxable income
    final taxableIncome = incomeBeforeTax - personalDeduction - dependentDeduction;

    // Calculate tax
    final personalIncomeTax = calculatePersonalIncomeTax(taxableIncome);

    // Net salary
    final netSalary = incomeBeforeTax - personalIncomeTax;

    // Tax breakdown
    final taxBreakdown = calculateTaxBreakdown(taxableIncome);

    return SalaryResult(
      gross: grossSalary,
      socialInsurance: socialInsurance,
      healthInsurance: healthInsurance,
      unemploymentInsurance: unemploymentInsurance,
      totalInsurance: totalInsurance,
      incomeBeforeTax: incomeBeforeTax,
      personalDeduction: personalDeduction,
      dependentDeduction: dependentDeduction,
      taxableIncome: taxableIncome > 0 ? taxableIncome : 0,
      personalIncomeTax: personalIncomeTax,
      net: netSalary,
      taxBreakdown: taxBreakdown,
    );
  }

  @override
  SalaryResult calculateNetToGross({
    required double netSalary,
    required int dependents,
  }) {
    // Estimate initial gross salary
    double estimatedGross = netSalary * 1.2;

    // Iterate to find accurate gross
    for (int i = 0; i < SalaryConstants.maxIterations; i++) {
      final result = calculateGrossToNet(
        grossSalary: estimatedGross,
        dependents: dependents,
      );
      
      final diff = netSalary - result.net;
      
      if (diff.abs() < SalaryConstants.convergenceThreshold) break;
      estimatedGross += diff;
    }

    return calculateGrossToNet(
      grossSalary: estimatedGross,
      dependents: dependents,
    );
  }

  @override
  double calculatePersonalIncomeTax(double taxableIncome) {
    if (taxableIncome <= 0) return 0;

    double tax = 0;
    double previousLimit = 0;

    for (final bracket in SalaryConstants.taxBrackets) {
      if (taxableIncome <= previousLimit) break;

      final taxableAmount = taxableIncome > bracket.limit
          ? bracket.limit - previousLimit
          : taxableIncome - previousLimit;

      tax += taxableAmount * bracket.rate;
      previousLimit = bracket.limit;

      if (taxableIncome <= bracket.limit) break;
    }

    return tax;
  }

  @override
  Map<String, double> calculateTaxBreakdown(double taxableIncome) {
    if (taxableIncome <= 0) {
      return {
        'bracket1': 0,
        'bracket2': 0,
        'bracket3': 0,
        'bracket4': 0,
        'bracket5': 0,
        'bracket6': 0,
        'bracket7': 0,
      };
    }

    final breakdown = <String, double>{};
    double previousLimit = 0;

    for (int i = 0; i < SalaryConstants.taxBrackets.length; i++) {
      final bracket = SalaryConstants.taxBrackets[i];
      
      if (taxableIncome <= previousLimit) {
        breakdown['bracket${i + 1}'] = 0;
      } else {
        final taxableAmount = taxableIncome > bracket.limit
            ? bracket.limit - previousLimit
            : taxableIncome - previousLimit;
        
        breakdown['bracket${i + 1}'] = taxableAmount * bracket.rate;
      }

      previousLimit = bracket.limit;
      if (taxableIncome <= bracket.limit) {
        // Fill remaining brackets with 0
        for (int j = i + 1; j < SalaryConstants.taxBrackets.length; j++) {
          breakdown['bracket${j + 1}'] = 0;
        }
        break;
      }
    }

    return breakdown;
  }
}
