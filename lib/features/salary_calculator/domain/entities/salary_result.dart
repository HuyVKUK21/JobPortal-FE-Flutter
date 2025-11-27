class SalaryResult {
  final double gross;
  final double socialInsurance;
  final double healthInsurance;
  final double unemploymentInsurance;
  final double totalInsurance;
  final double incomeBeforeTax;
  final double personalDeduction;
  final double dependentDeduction;
  final double taxableIncome;
  final double personalIncomeTax;
  final double net;
  final Map<String, double> taxBreakdown;

  const SalaryResult({
    required this.gross,
    required this.socialInsurance,
    required this.healthInsurance,
    required this.unemploymentInsurance,
    required this.totalInsurance,
    required this.incomeBeforeTax,
    required this.personalDeduction,
    required this.dependentDeduction,
    required this.taxableIncome,
    required this.personalIncomeTax,
    required this.net,
    required this.taxBreakdown,
  });

  Map<String, double> toMap() {
    return {
      'gross': gross,
      'socialInsurance': socialInsurance,
      'healthInsurance': healthInsurance,
      'unemploymentInsurance': unemploymentInsurance,
      'totalInsurance': totalInsurance,
      'incomeBeforeTax': incomeBeforeTax,
      'personalDeduction': personalDeduction,
      'dependentDeduction': dependentDeduction,
      'taxableIncome': taxableIncome,
      'personalIncomeTax': personalIncomeTax,
      'net': net,
    };
  }
}
