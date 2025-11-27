class SalaryStrings {
  SalaryStrings._();

  // Page title
  static const String pageTitle = 'Tính lương Gross - Net';

  // Section titles
  static const String regulationTitle = 'Áp dụng quy định';
  static const String incomeTitle = 'Thu nhập';
  static const String insuranceTitle = 'Đóng bảo hiểm';
  static const String regionTitle = 'Vùng (Giải thích)';
  static const String dependentsTitle = 'Số người phụ thuộc';

  // Regulation options
  static const String newRegulation = 'Từ 01/07/2022 (Quy định mới)';
  static const String oldRegulation = 'Từ 01/07/2020 - 30/06/2022';

  // Insurance options
  static const String insuranceOnSalary = 'Trên mức lương chính thức';
  static const String insuranceOther = 'Khác';

  // Regions
  static const String regionI = 'I';
  static const String regionII = 'II';
  static const String regionIII = 'III';
  static const String regionIV = 'IV';

  // Button labels
  static const String netToGross = 'Net → Gross';
  static const String grossToNet = 'Gross → Net';

  // Result section titles
  static const String detailBreakdown = 'Diễn giải chi tiết';
  static const String taxBreakdown = 'Chi tiết thuế TNCN';
  static const String employerContribution = 'Người sử dụng lao động trả';
  static const String currency = '(VNĐ)';

  // Result labels
  static const String grossSalary = 'Lương GROSS';
  static const String socialInsurance = 'Bảo hiểm xã hội (8%)';
  static const String healthInsurance = 'Bảo hiểm y tế (1.5%)';
  static const String unemploymentInsurance = 'Bảo hiểm thất nghiệp (1%)';
  static const String incomeBeforeTax = 'Thu nhập trước thuế';
  static const String personalDeduction = 'Giảm trừ gia cảnh bản thân';
  static const String dependentDeduction = 'Giảm trừ gia cảnh người phụ thuộc';
  static const String taxableIncome = 'Thu nhập chịu thuế';
  static const String personalIncomeTax = 'Thuế thu nhập cá nhân';
  static const String netSalary = 'Lương NET';
  static const String total = 'Tổng cộng';

  // Employer contributions
  static const String employerSocialInsurance = 'Bảo hiểm xã hội (17%)';
  static const String employerAccidentInsurance = 'Bảo hiểm tai nạn lao động - Bệnh nghề nghiệp (0.5%)';
  static const String employerHealthInsurance = 'Bảo hiểm y tế';
  static const String employerUnemploymentInsurance = 'Bảo hiểm thất nghiệp';

  // Tax brackets
  static const String taxBracket1 = 'Đến 5 triệu VNĐ (5%)';
  static const String taxBracket2 = 'Trên 5 triệu VNĐ đến 10 triệu VNĐ (10%)';
  static const String taxBracket3 = 'Trên 10 triệu VNĐ đến 18 triệu VNĐ (15%)';
  static const String taxBracket4 = 'Trên 18 triệu VNĐ đến 32 triệu VNĐ (20%)';
  static const String taxBracket5 = 'Trên 32 triệu VNĐ đến 52 triệu VNĐ (25%)';
  static const String taxBracket6 = 'Trên 52 triệu VNĐ đến 80 triệu VNĐ (30%)';
  static const String taxBracket7 = 'Trên 80 triệu VNĐ (35%)';

  // Hints and placeholders
  static const String salaryPlaceholder = '10000000';
  static const String salaryHint = 'Nhập số không có dấu phẩy';
  static const String dependentsPlaceholder = '0';
  static const String dependentsUnit = '(Người)';

  // Messages
  static const String enterIncome = 'Vui lòng nhập thu nhập';
  static const String incomeGreaterThanZero = 'Thu nhập phải lớn hơn 0';
  static const String calculationSuccess = 'Tính toán thành công!';
}
