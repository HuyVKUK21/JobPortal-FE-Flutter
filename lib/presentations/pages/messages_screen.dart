import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/lottie_assets.dart';
import 'package:flutter_application_1/core/data/sample_messages_data.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/widgets/conversation_list_item.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final conversations = SampleMessagesData.conversations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Tin nhắn',
              iconHeaderLeftBar: Icons.search,
              iconHeaderRightBar: Icons.more_horiz_rounded,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: conversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.spaceXL),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              LottieAssets.noResultFound,
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: AppDimensions.spaceL),
                            const Text(
                              'Chưa có tin nhắn',
                              style: TextStyle(
                                fontSize: AppDimensions.fontXL,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            const Text(
                              'Tin nhắn từ nhà tuyển dụng sẽ hiển thị ở đây',
                              style: TextStyle(
                                fontSize: AppDimensions.fontM,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: conversations.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey[200],
                        indent: 68,
                      ),
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];
                        return ConversationListItem(
                          conversation: conversation,
                          onTap: () {
                            context.pushNamed(
                              'chatDetail',
                              extra: conversation,
                            );
                          },
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
