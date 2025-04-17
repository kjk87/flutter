import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:divigo/core/localization/app_localization.dart';

class LotteryGuideScreen extends StatelessWidget {
  const LotteryGuideScreen({super.key});

  Widget _buildInfoRow(String svgIcon, Widget content) {
    return Row(
      children: [
        SvgPicture.string(
          svgIcon,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 16),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildNumberedRow(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6C72CB),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(text),
      ],
    );
  }

  Widget _buildPrizeCard(BuildContext context) {
    final local = AppLocalization.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            local.get('dailyPrizeAmount'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPrizeRow(Icons.emoji_events, Colors.amber, local.get('rank1'),
              '1000000', local.get('winners1')),
          _buildPrizeRow(Icons.emoji_events, Colors.grey[400]!,
              local.get('rank2'), '500000', local.get('winners2')),
          _buildPrizeRow(Icons.emoji_events, Colors.brown[300]!,
              local.get('rank3'), '100000', local.get('winners10')),
          Divider(height: 24),
          _buildNormalPrizeRow(
              context, local.get('rank4'), '10000', local.get('winners50')),
          _buildNormalPrizeRow(
              context, local.get('rank5'), '5000', local.get('winners100')),
          _buildNormalPrizeRow(
              context, local.get('rank6'), '1000', local.get('winners500')),
          _buildNormalPrizeRow(
              context, local.get('rank7'), '500', local.get('winners1000')),
          _buildNormalPrizeRow(
              context, local.get('rank8'), '100', local.get('winners5000')),
          _buildNormalPrizeRow(
              context, local.get('rank9'), '20', local.get('winnersAll')),
          _buildNormalPrizeRow(
              context, local.get('rank10'), '10', local.get('winnersAll')),
          _buildNormalPrizeRow(
              context, local.get('rankOther'), '1~9', local.get('winnersAll')),
        ],
      ),
    );
  }

  Widget _buildPrizeRow(
      IconData icon, Color color, String rank, String prize, String count) {
    final points = _extractPoints(prize);
    final f = NumberFormat('###,###,###,###');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(rank),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                f.format(int.parse(prize)) + 'P',
                textAlign: TextAlign.end,
              ),
              Text(
                '(\$${(points / 10000).toStringAsFixed(0)})',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            child: Text(
              count,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalPrizeRow(
      BuildContext context, String rank, String prize, String count) {
    final local = AppLocalization.of(context);
    final points = _extractPoints(prize);
    final f = NumberFormat('###,###,###,###');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(rank),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rank != local.get('rankOther')
                    ? f.format(int.parse(prize)) + 'P'
                    : prize + 'P',
                textAlign: TextAlign.end,
              ),
              if (rank != local.get('rankOther')) // 1~8포인트는 표시하지 않음
                Text(
                  '(\$${(points / 10000).toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '')})',
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
            ],
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            child: Text(
              count,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // 포인트 문자열에서 숫자만 추출하는 헬퍼 메서드
  int _extractPoints(String prize) {
    if (prize.contains('~')) return 0; // 범위 표시(예: "1~9")인 경우 0 반환

    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(prize);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    // money bag SVG
    final moneyBagSvg = '''
      <svg width="40" height="40" viewBox="0 0 40 40">
        <path d="M20 5 L28 12 L28 30 C28 32.2 26.2 34 24 34 L16 34 C13.8 34 12 32.2 12 30 L12 12 L20 5Z" 
          fill="#6C72CB" fill-opacity="0.1" stroke="#6C72CB" stroke-width="1.5"/>
        <path d="M16 12 L24 12" stroke="#6C72CB" stroke-width="1.5" stroke-linecap="round"/>
        <path d="M20 17 C22.5 17 24.5 19 24.5 21.5 C24.5 24 22.5 26 20 26 C17.5 26 15.5 24 15.5 21.5 C15.5 19 17.5 17 20 17Z" 
          fill="#6C72CB" fill-opacity="0.2"/>
        <path d="M20 19 L20 24 M18 21.5 L22 21.5" stroke="#6C72CB" stroke-width="1.5" stroke-linecap="round"/>
      </svg>
    ''';

    // money stack SVG
    final moneyStackSvg = '''
      <svg width="40" height="40" viewBox="0 0 40 40">
        <rect x="8" y="22" width="24" height="12" rx="2" 
          fill="#6C72CB" fill-opacity="0.1" stroke="#6C72CB" stroke-width="1.5"/>
        <rect x="10" y="17" width="20" height="12" rx="2" 
          fill="#6C72CB" fill-opacity="0.15" stroke="#6C72CB" stroke-width="1.5"/>
        <rect x="12" y="12" width="16" height="12" rx="2" 
          fill="#6C72CB" fill-opacity="0.2" stroke="#6C72CB" stroke-width="1.5"/>
        <path d="M20 16 L20 20 M18 18 L22 18" stroke="#6C72CB" stroke-width="1.5" stroke-linecap="round"/>
        <path d="M20 21 L20 25 M18 23 L22 23" stroke="#6C72CB" stroke-width="1.5" stroke-linecap="round"/>
        <path d="M20 26 L20 30 M18 28 L22 28" stroke="#6C72CB" stroke-width="1.5" stroke-linecap="round"/>
      </svg>
    ''';

    return Scaffold(
      appBar: AppBar(
        title: Text(local.get('lotteryGuide')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.get('whatIsLottery'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    moneyBagSvg,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(local.get('noFailLottery')),
                        Text(local.get('guaranteedPrize')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    moneyStackSvg,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(local.get('dailyMillionWinner')),
                        Text(local.get('dailyWinners')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    local.get('howToGetLottery'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNumberedRow('1', local.get('playGameGetOne')),
                  const SizedBox(height: 8),
                  _buildNumberedRow('2', local.get('walkStepsGetOne')),
                  const SizedBox(height: 8),
                  _buildNumberedRow('3', local.get('attendanceGetOne')),
                  const SizedBox(height: 24),
                  _buildPrizeCard(context),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      local.get('prizeAdjustment'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
