import 'package:flutter_application_1/features/salary_calculator/domain/entities/salary_result.dart';

abstract class SalaryCalculatorRepository {
  SalaryResult calculateGrossToNet({
    required double grossSalary,
    required int dependents,
  });

  SalaryResult calculateNetToGross({
    required double netSalary,
    required int dependents,
  });

  double calculatePersonalIncomeTax(double taxableIncome);

  Map<String, double> calculateTaxBreakdown(double taxableIncome);
}
