import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/models/profile.dart';
import 'package:flutter_application_1/core/widgets/date_picker_field.dart';
import 'package:intl/intl.dart';

/// Dialog for adding or editing work experience entries
class WorkExperienceFormDialog extends StatefulWidget {
  final WorkExperienceDTO? experience;

  const WorkExperienceFormDialog({
    super.key,
    this.experience,
  });

  @override
  State<WorkExperienceFormDialog> createState() => _WorkExperienceFormDialogState();
}

class _WorkExperienceFormDialogState extends State<WorkExperienceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;

  @override
  void initState() {
    super.initState();
    if (widget.experience != null) {
      _companyController.text = widget.experience!.company;
      _positionController.text = widget.experience!.position;
      _descriptionController.text = widget.experience!.description;

      try {
        _startDate = DateFormat('yyyy-MM-dd').parse(widget.experience!.startDate);
      } catch (e) {
        _startDate = null;
      }

      if (widget.experience!.endDate != null) {
        try {
          _endDate = DateFormat('yyyy-MM-dd').parse(widget.experience!.endDate!);
        } catch (e) {
          _endDate = null;
        }
      } else {
        _isCurrentlyWorking = true;
      }
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
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

      if (!_isCurrentlyWorking && _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ngày kết thúc hoặc đánh dấu đang làm việc'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_isCurrentlyWorking &&
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

      final experience = WorkExperienceDTO(
        company: _companyController.text.trim(),
        position: _positionController.text.trim(),
        startDate: _formatDateForApi(_startDate),
        endDate: _isCurrentlyWorking ? null : _formatDateForApi(_endDate),
        description: _descriptionController.text.trim(),
      );

      Navigator.of(context).pop(experience);
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
                          Icons.work,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.experience == null
                              ? 'Thêm kinh nghiệm'
                              : 'Chỉnh sửa kinh nghiệm',
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

                  // Company
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: 'Công ty *',
                      hintText: 'VD: ABC Tech Company',
                      prefixIcon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tên công ty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Position
                  TextFormField(
                    controller: _positionController,
                    decoration: InputDecoration(
                      labelText: 'Vị trí *',
                      hintText: 'VD: Senior Developer',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập vị trí làm việc';
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

                  // Currently Working Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isCurrentlyWorking,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyWorking = value ?? false;
                            if (_isCurrentlyWorking) {
                              _endDate = null;
                            }
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Đang làm việc',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // End Date
                  if (!_isCurrentlyWorking)
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

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Mô tả công việc',
                      hintText: 'Mô tả chi tiết về công việc và trách nhiệm...',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
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
                          widget.experience == null ? 'Thêm' : 'Lưu',
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
