import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的钱包'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBalanceCard(),
            _buildCommissionChart(),
            _buildCommissionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingL),
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: AppColors.elevatedShadow(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '可提现金额',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          const Text(
            '¥1,234.56',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXXXL,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('本月预估', '¥567.89'),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildInfoItem('累计提现', '¥8,901.23'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('立即提现'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeS,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundColor(Theme.of(context).brightness),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: AppColors.cardShadow(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '佣金趋势',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _buildTimeFilter('7天', true),
                  _buildTimeFilter('30天', false),
                  _buildTimeFilter('90天', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 100),
                      FlSpot(1, 150),
                      FlSpot(2, 120),
                      FlSpot(3, 200),
                      FlSpot(4, 180),
                      FlSpot(5, 250),
                      FlSpot(6, 300),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeS,
            color: isSelected ? Colors.white : AppColors.grey600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionList() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '佣金明细',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildCommissionItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(
              PhosphorIcons.shoppingCart(),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '商品订单佣金',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '2024-01-${10 + index} 14:30',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+¥${(index + 1) * 10}.00',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeL,
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}