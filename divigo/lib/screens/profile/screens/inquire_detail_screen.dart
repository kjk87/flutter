import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class InquireDetailScreen extends StatefulWidget {
  const InquireDetailScreen({super.key});

  @override
  State<InquireDetailScreen> createState() => _InquireDetailScreenState();
}

class _InquireDetailScreenState extends State<InquireDetailScreen> {
  late String type = 'General';
  late String title = '';
  late String contents = '';
  late List<dynamic> images = ['upload'];
  final picker = ImagePicker();
  XFile? image;
  List<XFile?> multiImage = [];
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).get('inquire'),
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFF333333),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 메인 콘텐츠
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 문의 유형 선택
                        Text(
                          AppLocalization.of(context).get('inquiryType'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTypeSelector(),
                        const SizedBox(height: 24),

                        // 제목 입력
                        Text(
                          AppLocalization.of(context).get('inquiryTitle'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTitleInput(),
                        const SizedBox(height: 24),

                        // 내용 입력
                        Text(
                          AppLocalization.of(context).get('inquiryContent'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildContentsInput(),
                        const SizedBox(height: 24),

                        // 이미지 첨부
                        Text(
                          AppLocalization.of(context).get('attachedImage'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildImageGrid(),
                      ],
                    ),
                  ),
                ),

                // 하단 제출 버튼
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTypeOption(
              'General', AppLocalization.of(context).get('inquiryTypeGeneral')),
          _buildTypeOption('Partnership',
              AppLocalization.of(context).get('inquiryTypePartnership')),
          _buildTypeOption(
              'Error', AppLocalization.of(context).get('inquiryTypeError')),
          _buildTypeOption(
              'Other', AppLocalization.of(context).get('inquiryTypeOther')),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String value, String label) {
    final bool isSelected = type == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            type = value;
          });
        },
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C72CB) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: AppLocalization.of(context).get('inquiryTitleHint'),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF6C72CB),
            width: 1,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF333333),
      ),
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalization.of(context).get('inquiryTitleRequired');
        }
        return null;
      },
    );
  }

  Widget _buildContentsInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: AppLocalization.of(context).get('inquiryContentHint'),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF6C72CB),
            width: 1,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF333333),
      ),
      maxLines: 6,
      onChanged: (value) {
        setState(() {
          contents = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalization.of(context).get('inquiryContentRequired');
        }
        return null;
      },
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      itemCount: images.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return images[index] == 'upload'
            ? _buildUploadButton()
            : images[index] == 'temp'
                ? _buildLoadingImage()
                : _buildImageItem(index);
      },
    );
  }

  Widget _buildUploadButton() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          color: Color(0xFF6C72CB),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              images.removeAt(index);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 14,
              color: Color(0xFF6C72CB),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitInquiry,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C72CB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(AppLocalization.of(context).get('inquiry')),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      multiImage = await picker.pickMultiImage();
      if (multiImage.isNotEmpty) {
        for (var img in multiImage) {
          if (img != null) {
            setState(() {
              images.add('temp');
            });

            var formData = FormData.fromMap(
                {'file': await MultipartFile.fromFile(img.path)});
            var result =
                await dioUpload(path: '/file/s3Upload', params: formData);

            log(result.toString());

            if (result['code'] == 200) {
              setState(() {
                images.removeAt(images.length - 1);
                images.add(result['result']);
              });
            } else {
              setState(() {
                images.removeAt(images.length - 1);
              });
              _showErrorDialog(
                  AppLocalization.of(context).get('imageUploadError'));
            }
          }
        }
      }
    } catch (e) {
      log('이미지 선택 오류: $e');
      _showErrorDialog(AppLocalization.of(context).get('imageSelectError'));
    }
  }

  Future<void> _submitInquiry() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (title.isEmpty || contents.isEmpty) {
      _showErrorDialog(
          AppLocalization.of(context).get('titleAndContentsEmpty'));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      var res = await httpPost(path: '/inquire', params: {
        'imageList': images.length > 1 ? images.sublist(1) : [],
        'title': title,
        'contents': contents,
        'type': type
      });

      setState(() {
        _isSubmitting = false;
      });

      if (res['code'] == 200) {
        Navigator.of(context).pop(true);
      } else {
        _showErrorDialog(
            AppLocalization.of(context).get('inquiryRegisterError'));
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      _showErrorDialog(AppLocalization.of(context).get('inquiryRegisterError'));
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            AppLocalization.of(context).get('alert'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C72CB),
              ),
              child: Text(AppLocalization.of(context).get('confirm')),
            ),
          ],
        );
      },
    );
  }
}
