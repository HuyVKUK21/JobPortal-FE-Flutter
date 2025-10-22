import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/presentations/widgets/header_section_job_detail.dart';
import 'package:flutter_application_1/presentations/widgets/job_detail_infomation.dart';
import 'package:flutter_application_1/presentations/widgets/job_detail_infomation_summary.dart';
import 'package:flutter_application_1/presentations/widgets/job_details_infomation_header.dart';
import 'package:flutter_application_1/presentations/widgets/job_skill.dart';
import 'package:flutter_application_1/presentations/widgets/job_task_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailJob extends StatefulWidget {
  const DetailJob({super.key});

  @override
  State<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
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

  void _applyJob() {
    context.pushNamed('applyJob');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final itemDesc = [
      'Phát triển và bảo trì ứng dụng Flutter.',
      'Phối hợp với team backend để tích hợp API.',
      'Tối ưu hiệu suất và trải nghiệm người dùng.',
      'Tham gia review code và đề xuất cải tiến.',
    ];

    final minQualification = [
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

    final aboutItems = [
      'Lutech Việt Nam là công ty công nghệ chuyên cung cấp giải pháp phần mềm toàn diện cho doanh nghiệp.',
      'Chúng tôi sở hữu đội ngũ kỹ sư giàu kinh nghiệm, đam mê sáng tạo và luôn hướng đến chất lượng cao nhất.',
      'Lutech đã hợp tác với nhiều đối tác trong lĩnh vực tài chính, giáo dục, y tế và thương mại điện tử.',
      'Triết lý hoạt động của chúng tôi là đặt con người và công nghệ làm trung tâm phát triển bền vững.',
      'Tầm nhìn: Trở thành công ty công nghệ hàng đầu Đông Nam Á trong lĩnh vực chuyển đổi số.',
      'Sứ mệnh: Cung cấp giải pháp phần mềm hiệu quả, thân thiện và mang lại giá trị thực cho doanh nghiệp.',
      'Giá trị cốt lõi: Sáng tạo – Tận tâm – Hợp tác – Phát triển bền vững.',
    ];

    final sections = [
      JobDetailInfomation(items: itemDesc, title: 'Mô tả công việc'),
      JobDetailInfomation(items: minQualification, title: 'Yêu cầu tối thiểu'),
      JobSkill(categories: skills, title: 'Yêu cầu kỹ năng'),
      const JobDetailInfomationSummary(title: 'Tóm tắt công việc'),
      JobDetailInfomation(items: aboutItems, title: 'Chi tiết về công ty'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSectionJobDetail(),
            const SizedBox(height: 12),
            const JobDetailInfomationHeader(),
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

            // Apply Button
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _applyJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Ứng tuyển',
                  style: TextStyle(
                    fontSize: AppDimensions.fontL,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
