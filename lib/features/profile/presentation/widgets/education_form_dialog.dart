import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/models/profile.dart';
import 'package:flutter_application_1/core/widgets/date_picker_field.dart';
import 'package:intl/intl.dart';

/// Dialog for adding or editing education entries
class EducationFormDialog extends StatefulWidget {
  final EducationDTO? education;

  const EducationFormDialog({
    super.key,
    this.education,
  });

  @override
  State<EducationFormDialog> createState() => _EducationFormDialogState();
}

class _EducationFormDialogState extends State<EducationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyStudying = false;

  @override
  void initState() {
    super.initState();
    if (widget.education != null) {
      _institutionController.text = widget.education!.institution;
      _degreeController.text = widget.education!.degree;
      _fieldOfStudyController.text = widget.education!.fieldOfStudy;

      try {
        _startDate = DateFormat('yyyy-MM-dd').parse(widget.education!.startDate);
      } catch (e) {
        _startDate = null;
      }

      if (widget.education!.endDate != null) {
        try {
          _endDate = DateFormat('yyyy-MM-dd').parse(widget.education!.endDate!);
        } catch (e) {
          _endDate = null;
        }
      } else {
        _isCurrentlyStudying = true;
      }
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    super.dispose();
  }

  String _formatDateForApi(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ngày bắt đầu'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_isCurrentlyStudying && _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ngày kết thúc hoặc đánh dấu đang học'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_isCurrentlyStudying &&
          _endDate != null &&
          _startDate != null &&
          _endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ngày kết thúc phải sau ngày bắt đầu'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final education = EducationDTO(
        institution: _institutionController.text.trim(),
        degree: _degreeController.text.trim(),
        fieldOfStudy: _fieldOfStudyController.text.trim(),
        startDate: _formatDateForApi(_startDate),
        endDate: _isCurrentlyStudying ? null : _formatDateForApi(_endDate),
      );

      Navigator.of(context).pop(education);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.education == null ? 'Thêm học vấn' : 'Chỉnh sửa học vấn',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Institution
                  TextFormField(
                    controller: _institutionController,
                    decoration: InputDecoration(
                      labelText: 'Trường/Học viện *',
                      hintText: 'VD: Đại học Bách Khoa Hà Nội',
                      prefixIcon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tên trường';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Degree
                  TextFormField(
                    controller: _degreeController,
                    decoration: InputDecoration(
                      labelText: 'Bằng cấp *',
                      hintText: 'VD: Bachelor, Master, PhD',
                      prefixIcon: const Icon(Icons.workspace_premium),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập bằng cấp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field of Study
                  TextFormField(
                    controller: _fieldOfStudyController,
                    decoration: InputDecoration(
                      labelText: 'Ngành học *',
                      hintText: 'VD: Computer Science',
                      prefixIcon: const Icon(Icons.auto_stories),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập ngành học';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Start Date
                  DatePickerField(
                    label: 'Ngày bắt đầu *',
                    selectedDate: _startDate,
                    onDateSelected: (date) {
                      setState(() => _startDate = date);
                    },
                    hint: 'Chọn ngày bắt đầu',
                    lastDate: DateTime.now(),
                  ),
                  const SizedBox(height: 16),

                  // Currently Studying Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isCurrentlyStudying,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyStudying = value ?? false;
                            if (_isCurrentlyStudying) {
                              _endDate = null;
                            }
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Đang học',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // End Date
                  if (!_isCurrentlyStudying)
                    DatePickerField(
                      label: 'Ngày kết thúc *',
                      selectedDate: _endDate,
                      onDateSelected: (date) {
                        setState(() => _endDate = date);
                      },
                      hint: 'Chọn ngày kết thúc',
                      firstDate: _startDate,
                      lastDate: DateTime(2100),
                    ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.education == null ? 'Thêm' : 'Lưu',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
