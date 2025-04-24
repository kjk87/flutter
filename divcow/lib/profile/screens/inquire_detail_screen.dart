import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/profile/components/checkbox.dart';
import 'package:divcow/profile/components/inputbox.dart';
import 'package:divcow/profile/components/linear_one_button.dart';
import 'package:easy_localization/easy_localization.dart';
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
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수

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
        appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: tr('inquireDetail')),
        resizeToAvoidBottomInset: false,
        backgroundColor: DivcowColor.background,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: DivcowColor.background,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      inquireCheckbox('General', type == 'General', () {setState(() {type = 'General';});}),
                      inquireCheckbox('Partnership', type == 'Partnership', () {setState(() {type = 'Partnership';});}),
                      inquireCheckbox('Error', type == 'Error', () {setState(() {type = 'Error';});}),
                      inquireCheckbox('Other', type == 'Other', () {setState(() {type = 'Other';});})
                    ],
                  ),
                  inquireInputbox(tr('inquiryTitle'), [0, 20, 0, 0], (text) {setState(() {title = text;});}),
                  inquireInputbox(tr('inquiryContents'), [0, 20, 0, 0], (text) {setState(() {contents = text;});}),
                  SizedBox(height: 20,),
                  Text(tr('attachImage'), style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, )),
                  SizedBox(height: 10,),
                  Expanded(
                    child: GridView.builder(
                      itemCount: images.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1/1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10
                      ), 
                      itemBuilder: (BuildContext context, int index) {
                        return images[index] == 'upload' ?
                        InkWell(
                          onTap: () async {
                            multiImage = await picker.pickMultiImage();
                            if(multiImage != null) {
                              for(var img in multiImage) {
                                if(img != null) {
                                  setState(() {
                                    images.add('temp');
                                  });

                                  var formData = FormData.fromMap({'file': await MultipartFile.fromFile(img.path)});
                                  var result = await dioUpload(path: '/file/s3Upload', params: formData);
                                  
                                  log(result.toString());

                                  if(result['code'] == 200) {
                                    setState(() {
                                      images.removeAt(images.length - 1);
                                      images.add(result['result']);
                                    });
                                  }
                                }
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: DivcowColor.card,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/inquire_image_upload.png'),
                          ),
                        )
                        :
                        images[index] == 'temp' ?
                        circleIndicator()
                        :
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CachedNetworkImage(
                              imageUrl: images[index],
                              placeholder: (context, url) => Image.asset('assets/images/ic_profile_default.png'),
                              errorWidget: (context, url,error) => Image.asset('assets/images/ic_profile_default.png'),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5, right: 5, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
                                child: Image.asset('assets/images/inquire_image_delete.png'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  profileLinearOneButton(tr('contact'), 40, [10, 10, 10, 20], (click) async {

                    if(title != '' && contents != '') {
                      var res = await httpPost(
                        path: '/inquire',
                        params: {
                          'imageList': images.sublist(1),
                          'title': title,
                          'contents': contents,
                          'type': type
                        }
                      );

                      if(res['code'] == 200) {
                        Navigator.of(context).pop(true);
                      } else {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return Dialog(
                              backgroundColor: DivcowColor.popup,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 50,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('error', style: TextStyle(fontSize: 17, color: DivcowColor.textDefault),),
                                    ],
                                  ),
                                  SizedBox(height: 50,),
                                ],
                              )

                            );
                          }
                        );
                      }
                    } else {
                      showDialog(
                        context: context, 
                        builder: (context) {
                          return Dialog(
                            backgroundColor: DivcowColor.popup,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 50,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(tr('inquireRequire'), style: TextStyle(fontSize: 17, color: DivcowColor.textDefault),),
                                  ],
                                ),
                                SizedBox(height: 50,),
                              ],
                            )

                          );
                        }
                      );
                    }

                  })
                ],
              )
            )
          )
        )
      )
    );
  }
}

