import 'package:flutter_application_1/features/salary_calculator/domain/entities/salary_result.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/repositories/salary_calculator_repository.dart';

class CalculateGrossToNetUseCase {
  final SalaryCalculatorRepository repository;

  CalculateGrossToNetUseCase(this.repository);

  SalaryResult call({
    required double grossSalary,
    required int dependents,
  }) {
    return repository.calculateGrossToNet(
      grossSalary: grossSalary,
      dependents: dependents,
    );
  }
}
