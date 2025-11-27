import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/salary_calculator/data/repositories/salary_calculator_repository_impl.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/repositories/salary_calculator_repository.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/usecases/calculate_gross_to_net.dart';
import 'package:flutter_application_1/features/salary_calculator/domain/usecases/calculate_net_to_gross.dart';

// Repository provider
final salaryCalculatorRepositoryProvider = Provider<SalaryCalculatorRepository>((ref) {
  return SalaryCalculatorRepositoryImpl();
});

// Use case providers
final calculateGrossToNetProvider = Provider<CalculateGrossToNetUseCase>((ref) {
  final repository = ref.watch(salaryCalculatorRepositoryProvider);
  return CalculateGrossToNetUseCase(repository);
});

final calculateNetToGrossProvider = Provider<CalculateNetToGrossUseCase>((ref) {
  final repository = ref.watch(salaryCalculatorRepositoryProvider);
  return CalculateNetToGrossUseCase(repository);
});
