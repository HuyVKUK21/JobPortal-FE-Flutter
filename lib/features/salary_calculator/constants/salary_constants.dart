class SalaryConstants {
  SalaryConstants._();

  // Insurance rates (employee contribution)
  static const double socialInsuranceRate = 0.08; // 8%
  static const double healthInsuranceRate = 0.015; // 1.5%
  static const double unemploymentInsuranceRate = 0.01; // 1%

  // Employer contribution rates
  static const double employerSocialInsuranceRate = 0.17; // 17%
  static const double employerHealthInsuranceRate = 0.03; // 3%
  static const double employerUnemploymentInsuranceRate = 0.01; // 1%
  static const double employerAccidentInsuranceRate = 0.005; // 0.5%

  // Tax deductions
  static const double personalDeduction = 11000000; // 11 million VND
  static const double dependentDeduction = 4400000; // 4.4 million VND per dependent

  // Tax brackets (progressive tax)
  static const List<TaxBracket> taxBrackets = [
    TaxBracket(limit: 5000000, rate: 0.05), // Up to 5M: 5%
    TaxBracket(limit: 10000000, rate: 0.10), // 5M-10M: 10%
    TaxBracket(limit: 18000000, rate: 0.15), // 10M-18M: 15%
    TaxBracket(limit: 32000000, rate: 0.20), // 18M-32M: 20%
    TaxBracket(limit: 52000000, rate: 0.25), // 32M-52M: 25%
    TaxBracket(limit: 80000000, rate: 0.30), // 52M-80M: 30%
    TaxBracket(limit: double.infinity, rate: 0.35), // Above 80M: 35%
  ];

  // UI Constants
  static const double borderRadius = 16.0;
  static const double cardPadding = 20.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 12.0;

  // Calculation constants
  static const int maxIterations = 10;
  static const double convergenceThreshold = 1000.0;
}

class TaxBracket {
  final double limit;
  final double rate;

  const TaxBracket({required this.limit, required this.rate});
}
