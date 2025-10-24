import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to search page
        context.pushNamed('searchJobs');
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          enabled: false, // Disable text input, only allow tap to navigate
          decoration: InputDecoration(
            hintText: 'Tìm kiếm từ khoá...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 181, 181, 181),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: Icon(Icons.filter_list, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
