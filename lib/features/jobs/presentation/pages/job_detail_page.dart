import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_detail_header.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_detail_info.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_detail_summary_card.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_detail_top_bar.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_skill_list.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_tab_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({super.key});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final tabs = ['Mô tả', 'Yêu cầu', 'Kỹ năng', 'Tóm tắt', 'Công ty'];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      final visible = positions
          .where((p) => p.itemLeadingEdge >= 0 && p.itemLeadingEdge < 0.4)
          .map((p) => p.index)
          .toList();
      if (visible.isNotEmpty && visible.first != currentTab) {
        setState(() => currentTab = visible.first);
      }
    });
  }

  void _scrollTo(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 50),
    );
    setState(() => currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final jobDescription = [
      'Phát triển và bảo trì ứng dụng Flutter.',
      'Phối hợp với team backend để tích hợp API.',
      'Tối ưu hiệu suất và trải nghiệm người dùng.',
      'Tham gia review code và đề xuất cải tiến.',
    ];

    final requirements = [
      'Tốt nghiệp Đại học CNTT hoặc các ngành liên quan.',
      'Ít nhất 2 năm kinh nghiệm phát triển ứng dụng Flutter.',
      'Hiểu biết tốt về REST API, JSON, và Clean Architecture.',
      'Kỹ năng giao tiếp và làm việc nhóm tốt.',
    ];

    final skills = [
      'Flutter',
      'ReactJS',
      'Angular',
      'VueJS',
      'NodeJS',
      'Dart',
      'JavaScript',
      'Python',
    ];

    final companyInfo = [
      'Lutech Việt Nam là công ty công nghệ chuyên cung cấp giải pháp phần mềm toàn diện cho doanh nghiệp.',
      'Chúng tôi sở hữu đội ngũ kỹ sư giàu kinh nghiệm, đam mê sáng tạo và luôn hướng đến chất lượng cao nhất.',
      'Lutech đã hợp tác với nhiều đối tác trong lĩnh vực tài chính, giáo dục, y tế và thương mại điện tử.',
    ];

    final sections = [
      JobDetailInfo(items: jobDescription, title: AppStrings.jobDescription),
      JobDetailInfo(items: requirements, title: AppStrings.requirements),
      JobSkillList(skills: skills, title: AppStrings.skills),
      JobDetailSummaryCard(title: AppStrings.summary),
      JobDetailInfo(items: companyInfo, title: AppStrings.companyInfo),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreenLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const JobDetailTopBar(),
            const SizedBox(height: 12),
            const JobDetailHeader(),
            const SizedBox(height: 8),
            JobTabBar(tabs: tabs, currentTab: currentTab, onTap: _scrollTo),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: sections[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


