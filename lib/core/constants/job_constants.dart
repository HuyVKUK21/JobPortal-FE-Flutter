/// Job-related constants
class JobConstants {
  JobConstants._();

  // Vietnamese Cities
  static const List<String> vietnameseCities = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Biên Hòa',
    'Nha Trang',
    'Huế',
    'Vũng Tàu',
    'Quy Nhơn',
    'Thái Nguyên',
    'Vinh',
    'Buôn Ma Thuột',
    'Đà Lạt',
    'Hạ Long',
  ];

  // Work Types
  static const String workTypeOnsite = 'Onsite (Làm việc tại văn phòng)';
  static const String workTypeRemote = 'Remote (Làm việc từ xa)';

  static const List<String> workTypes = [
    workTypeOnsite,
    workTypeRemote,
  ];

  // Job Levels
  static const String levelIntern = 'Thực tập / OJT';
  static const String levelEntryLevel = 'Nhân viên / Junior, Apprentice';
  static const String levelAssociate = 'Trưởng nhóm / Supervisor';
  static const String levelMidSenior = 'Trưởng phòng / Manager';
  static const String levelDirector = 'Giám đốc / Executive';

  static const List<String> jobLevels = [
    levelIntern,
    levelEntryLevel,
    levelAssociate,
    levelMidSenior,
    levelDirector,
  ];

  // Employment Types
  static const String employmentFullTime = 'Toàn thời gian';
  static const String employmentPartTime = 'Bán thời gian';
  static const String employmentFreelance = 'Freelance';
  static const String employmentContractual = 'Hợp đồng';

  static const List<String> employmentTypes = [
    employmentFullTime,
    employmentPartTime,
    employmentFreelance,
    employmentContractual,
  ];

  // Experience Levels
  static const String expNoExperience = 'Không kinh nghiệm';
  static const String exp1to5 = '1 - 5 Năm';
  static const String exp6to10 = '6 - 10 Năm';
  static const String expMoreThan10 = 'Hơn 10 Năm';

  static const List<String> experienceLevels = [
    expNoExperience,
    exp1to5,
    exp6to10,
    expMoreThan10,
  ];

  // Education Levels
  static const String eduLessThanHighSchool = 'Dưới THPT';
  static const String eduHighSchool = 'THPT';
  static const String eduAssociate = 'Cao đẳng';
  static const String eduBachelor = 'Đại học';
  static const String eduMaster = 'Thạc sĩ';
  static const String eduDoctoral = 'Tiến sĩ hoặc chuyên môn cao';

  static const List<String> educationLevels = [
    eduLessThanHighSchool,
    eduHighSchool,
    eduAssociate,
    eduBachelor,
    eduMaster,
    eduDoctoral,
  ];

  // Job Functions
  static const String funcAccounting = 'Kế toán và Tài chính';
  static const String funcAdministration = 'Hành chính và Điều phối';
  static const String funcArchitecture = 'Kiến trúc và Kỹ thuật';
  static const String funcArts = 'Nghệ thuật và Thể thao';
  static const String funcCustomerService = 'Dịch vụ khách hàng';
  static const String funcEducation = 'Giáo dục và Đào tạo';
  static const String funcGeneralServices = 'Dịch vụ chung';
  static const String funcHealth = 'Y tế và Dược';
  static const String funcHospitality = 'Khách sạn và Du lịch';
  static const String funcHumanResources = 'Nhân sự';
  static const String funcIT = 'CNTT và Phần mềm';
  static const String funcLegal = 'Pháp lý';
  static const String funcManagement = 'Quản lý và Tư vấn';
  static const String funcManufacturing = 'Sản xuất';
  static const String funcMedia = 'Truyền thông và Sáng tạo';
  static const String funcPublicService = 'Dịch vụ công và NGOs';
  static const String funcSafety = 'An toàn và Bảo mật';
  static const String funcSales = 'Bán hàng và Marketing';
  static const String funcSciences = 'Khoa học';
  static const String funcSupplyChain = 'Chuỗi cung ứng';
  static const String funcWriting = 'Viết lách và Nội dung';

  static const List<String> jobFunctions = [
    funcAccounting,
    funcAdministration,
    funcArchitecture,
    funcArts,
    funcCustomerService,
    funcEducation,
    funcGeneralServices,
    funcHealth,
    funcHospitality,
    funcHumanResources,
    funcIT,
    funcLegal,
    funcManagement,
    funcManufacturing,
    funcMedia,
    funcPublicService,
    funcSafety,
    funcSales,
    funcSciences,
    funcSupplyChain,
    funcWriting,
  ];

  // Sort Options
  static const String sortAlphabetical = 'Theo bảng chữ cái (A đến Z)';
  static const String sortMostRelevant = 'Phù hợp nhất';
  static const String sortHighestSalary = 'Lương cao nhất';
  static const String sortNewlyPosted = 'Mới đăng';
  static const String sortEndingSoon = 'Sắp hết hạn';

  static const List<String> sortOptions = [
    sortMostRelevant,
    sortAlphabetical,
    sortHighestSalary,
    sortNewlyPosted,
    sortEndingSoon,
  ];

  // Salary Range (in millions VND)
  static const double minSalary = 5;
  static const double maxSalary = 100;
}
