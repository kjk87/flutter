import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/screens/profile/components/management_checkbox.dart';
import 'package:divigo/screens/profile/components/management_countrybox.dart';
import 'package:divigo/screens/profile/components/management_datebox.dart';
import 'package:divigo/screens/profile/components/management_nicknamebox.dart';
import 'package:divigo/widgets/signin/bottom_alert_box.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:divigo/core/localization/app_localization.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  late dynamic user = {};

  late String id = '';
  late String nickname = '';
  late String birthday = '';
  late String country = '';
  late String gender = '';
  late String profile = '';
  late XFile image;

  final picker = ImagePicker();

  late dynamic nicknameReject = false;

  late bool alertNickname = false;
  late bool alertCheckNickname = false;
  bool isLoading = true;

  final TextEditingController idController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customInit();
  }

  @override
  void dispose() {
    idController.dispose();
    nicknameController.dispose();

    super.dispose();
  }

  customInit() async {
    try {
      final member = await getUser(context);
      setState(() {
        user = member;
        id = member?.userKey ?? '';
        nickname = member?.nickname ?? '';
        birthday = member?.birthday ?? '';
        country = member?.nation ?? '';
        gender = member?.gender ?? '';
        profile = member?.profile ?? '';

        // ID 컨트롤러에 userKey 설정
        idController.text = id;
        nicknameController.text = nickname;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(AppLocalization.of(context).get('profileLoadError'));
    }
  }

  Future<void> updateUser(click) async {
    if (nickname == '') {
      setState(() {
        alertNickname = true;
      });
      return;
    }

    if (nicknameReject == null || nicknameReject == true) {
      setState(() {
        alertCheckNickname = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var params = {
        'nation': country,
        'nickname': nickname,
        'birthday': birthday,
        'gender': gender,
        'profile': profile
      };

      var joinResult = await httpPost(path: '/member/update', params: params);
      if (joinResult['code'] == 200) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalization.of(context).get('profileUpdateSuccess')),
            backgroundColor: Color(0xFF6C72CB),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(AppLocalization.of(context).get('profileUpdateError'));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(AppLocalization.of(context).get('profileUpdateError'));
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          isLoading = true;
        });

        var formData = FormData.fromMap(
            {'file': await MultipartFile.fromFile(pickedFile.path)});

        var result = await dioUpload(path: '/file/s3Upload', params: formData);

        setState(() {
          isLoading = false;
        });

        if (result['code'] == 200) {
          setState(() {
            profile = result['result'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalization.of(context).get('profileImageUploadSuccess')),
              backgroundColor: Color(0xFF6C72CB),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          _showErrorDialog(AppLocalization.of(context).get('imageUploadError'));
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(AppLocalization.of(context).get('imageUploadError'));
    }
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
            AppLocalization.of(context).get('profileManagement'),
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
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraint) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Column(
                              children: [
                                const SizedBox(height: 24),

                                // 프로필 이미지
                                _buildProfileImage(),

                                const SizedBox(height: 24),

                                // 프로필 정보 폼
                                _buildProfileForm(),

                                const SizedBox(height: 32),

                                // 완료 버튼
                                ElevatedButton(
                                  onPressed: () => updateUser(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C72CB),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: Text(
                                      AppLocalization.of(context).get('save')),
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              // 알림 다이얼로그
              _buildAlertDialogs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: profile,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF6C72CB),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    const double fieldHeight = 52.0; // 모든 필드의 높이를 통일

    return Column(
      children: [
        // ID 필드
        _buildFormField(
          label: 'ID',
          child: SizedBox(
            height: fieldHeight,
            child: TextField(
              controller: idController,
              enabled: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 닉네임 필드
        _buildFormField(
          label: AppLocalization.of(context).get('nickname'),
          child: SizedBox(
            height: 52,
            child: Stack(
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() {
                      nickname = text;
                      nicknameReject = null;
                    });
                  },
                  controller: nicknameController,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(context).get('enterNickname'),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 0, 100, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: nicknameReject == null
                            ? Color(0xFF2575FC)
                            : nicknameReject
                                ? Color(0xFFFF5D5D)
                                : Color(0xFF77F5AE),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: nicknameReject == null
                            ? Color(0xFF2575FC)
                            : nicknameReject
                                ? Color(0xFFFF5D5D)
                                : Color(0xFF77F5AE),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: nicknameReject == null
                            ? Color(0xFF2575FC)
                            : nicknameReject
                                ? Color(0xFFFF5D5D)
                                : Color(0xFF77F5AE),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  bottom: 8,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (user.nickname != nickname) {
                        final res = await httpGetWithCode(
                            path: '/member/checkNickname?nickname=$nickname');
                        setState(() {
                          nicknameReject = !res;
                        });
                      } else {
                        setState(() {
                          nicknameReject = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF272564),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      AppLocalization.of(context).get('check'),
                      style: TextStyle(
                        color: Color(0xFF77F5AE),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 이메일 필드
        // _buildFormField(
        //   label: AppLocalization.of(context).get('email'),
        //   child: SizedBox(
        //     height: fieldHeight,
        //     child: TextField(
        //       controller: emailController,
        //       onChanged: (text) {
        //         setState(() {
        //           email = text;
        //         });
        //       },
        //       decoration: InputDecoration(
        //         contentPadding: const EdgeInsets.symmetric(
        //           horizontal: 16,
        //           vertical: 14,
        //         ),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(8),
        //           borderSide: BorderSide(
        //             color: Colors.grey.withOpacity(0.3),
        //           ),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(8),
        //           borderSide: BorderSide(
        //             color: Colors.grey.withOpacity(0.3),
        //           ),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(8),
        //           borderSide: const BorderSide(
        //             color: Color(0xFF6C72CB),
        //           ),
        //         ),
        //       ),
        //       style: const TextStyle(
        //         fontSize: 15,
        //         color: Color(0xFF333333),
        //       ),
        //       keyboardType: TextInputType.emailAddress,
        //     ),
        //   ),
        // ),

        const SizedBox(height: 16),

        // 생년월일 필드
        _buildFormField(
          label: AppLocalization.of(context).get('birthday'),
          child: InkWell(
            onTap: () async {
              var datetime = await showDatePicker(
                context: context,
                firstDate: DateTime(1000),
                lastDate: DateTime(2100),
              );
              if (datetime != null) {
                var date = datetime.toString();
                setState(() {
                  birthday = date.substring(0, 4) +
                      date.substring(5, 7) +
                      date.substring(8, 10);
                });
              }
            },
            child: Container(
              height: 52,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    birthday.isEmpty
                        ? AppLocalization.of(context).get('selectBirthday')
                        : birthday,
                    style: TextStyle(
                      color: birthday.isEmpty ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 국가 필드
        // _buildFormField(
        //   label: AppLocalization.of(context).get('country'),
        //   child: SizedBox(
        //     height: fieldHeight,
        //     child: managementCountrybox(
        //       context,
        //       AppLocalization.of(context).get('country'),
        //       [0, 0, 0, 0],
        //       (text) {
        //         setState(() {
        //           country = text;
        //         });
        //       },
        //       false,
        //       '',
        //       country,
        //     ),
        //   ),
        // ),

        // const SizedBox(height: 16),

        // 성별 필드
        _buildFormField(
          label: AppLocalization.of(context).get('gender'),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => gender = 'M'),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: gender == 'M' ? Color(0xFF6C72CB) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: gender == 'M'
                            ? Color(0xFF00FFCC)
                            : Colors.grey.withOpacity(0.3),
                        width: gender == 'M' ? 2 : 1,
                      ),
                      boxShadow: gender == 'M'
                          ? [
                              BoxShadow(
                                color: Color(0xFF6C72CB).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalization.of(context).get('male'),
                        style: TextStyle(
                          color: gender == 'M' ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: gender == 'M'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => gender = 'F'),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: gender == 'F' ? Color(0xFF6C72CB) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: gender == 'F'
                            ? Color(0xFF00FFCC)
                            : Colors.grey.withOpacity(0.3),
                        width: gender == 'F' ? 2 : 1,
                      ),
                      boxShadow: gender == 'F'
                          ? [
                              BoxShadow(
                                color: Color(0xFF6C72CB).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalization.of(context).get('female'),
                        style: TextStyle(
                          color: gender == 'F' ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: gender == 'F'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSelectBox({
    required String value,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF3E407C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isEmpty ? hintText : value,
              style: TextStyle(
                color: value.isEmpty
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white,
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String value,
    required String hintText,
    required Function(String) onChanged,
    required bool showCheckButton,
    required VoidCallback onCheckPressed,
  }) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: TextEditingController()..text = value,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF6C72CB),
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildAlertDialogs() {
    // if (alertEmail) {
    //   return Column(
    //     children: [
    //       Flexible(
    //         flex: 1,
    //         child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
    //       ),
    //       bottomAlertBox(AppLocalization.of(context).get('inputEmail'),
    //           AppLocalization.of(context).get('confirm'), () {
    //         setState(() {
    //           alertEmail = false;
    //         });
    //       })
    //     ],
    //   );
    // } else
      if (alertNickname) {
      return Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
          ),
          bottomAlertBox(AppLocalization.of(context).get('inputNickname'),
              AppLocalization.of(context).get('confirm'), () {
            setState(() {
              alertNickname = false;
            });
          })
        ],
      );
    } else if (alertCheckNickname) {
      return Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
          ),
          bottomAlertBox(AppLocalization.of(context).get('checkNickname'),
              AppLocalization.of(context).get('confirm'), () {
            setState(() {
              alertCheckNickname = false;
            });
          })
        ],
      );
    } else {
      return const SizedBox.shrink();
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
            AppLocalization.of(context).get('error'),
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
