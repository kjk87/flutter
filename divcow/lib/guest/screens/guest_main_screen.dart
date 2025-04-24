import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/guest/screens/attendance_reward_screen.dart';
import 'package:divcow/guest/screens/invitaion_reward_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GuestMainScreen extends StatelessWidget {
  const GuestMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DivcowColor.background,
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: DivcowColor.background,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvitaionRewardScreen()));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: DivcowColor.popup,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/ic_invite_reward.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 10),
                          Text(tr('invitationReward'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: DivcowColor.textDefault,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              )),
                          Text(
                              tr('invitationRewardDesc'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: DivcowColor.textDefault,
                                fontSize: 12.0,
                                // fontWeight: FontWeight.w700,
                              ))
                        ],
                      )),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceRewardScreen()));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: DivcowColor.popup,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/ic_attendance_reward.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 10),
                          Text(tr('attendanceReward'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: DivcowColor.textDefault,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              )),
                          Text(tr('attendanceRewardDesc'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: DivcowColor.textDefault,
                                fontSize: 12.0,
                                // fontWeight: FontWeight.w700,
                              ))
                        ],
                      )),
                )),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    color: DivcowColor.popup,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/ic_guest_coming_soon.png',
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Text(tr('comingSoon'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: DivcowColor.textDefault,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(
                          tr('comingSoonDesc'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: DivcowColor.textDefault,
                            fontSize: 12.0,
                            // fontWeight: FontWeight.w700,
                          ))
                    ],
                  )),
            ))
          ],
        ),
      ),
    ));
  }
}
