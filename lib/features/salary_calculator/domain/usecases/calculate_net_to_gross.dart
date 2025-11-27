import 'package:flutter_application_1/features/salary_calculator/domain/entities/salary_result.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/repositories/salary_calculator_repository.dart';

class CalculateNetToGrossUseCase {
  final SalaryCalculatorRepository repository;

  CalculateNetToGrossUseCase(this.repository);

  SalaryResult call({
    required double netSalary,
    required int dependents,
  }) {
    return repository.calculateNetToGross(
      netSalary: netSalary,
      dependents: dependents,
    );
  }
}
