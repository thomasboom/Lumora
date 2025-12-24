import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumora/l10n/app_localizations.dart';
import '../models/energy_entry.dart';
import '../models/insight_model.dart';
import '../services/insights_service.dart';
import '../services/storage_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final InsightsService _insightsService = InsightsService();
  final StorageService _storageService = StorageService();

  List<EnergyEntry> _entries = [];
  List<InsightModel> _insights = [];
  List<WeeklySummary> _weeklySummaries = [];
  List<TriggerInsight> _triggers = [];
  List<RecoveryTrend> _recoveryTrends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await _storageService.getEntries();

    if (mounted) {
      setState(() {
        _entries = entries;
        _insights = _insightsService.generateInsights(entries);
        _weeklySummaries = _insightsService.getWeeklySummaries(entries);
        _triggers = _insightsService.detectTriggers(entries);
        _recoveryTrends = _insightsService.getRecoveryTrends(entries);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF111827),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF6B7280)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          l10n.insightsTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noInsightsData,
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noInsightsDataSubtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInsightsCard(l10n),
                  const SizedBox(height: 24),
                  _buildWeeklySummaryCard(l10n),
                  const SizedBox(height: 24),
                  _buildTriggersCard(l10n),
                  const SizedBox(height: 24),
                  _buildRecoveryTrendsCard(l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildInsightsCard(AppLocalizations l10n) {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.personalizedInsights,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              _insights.length.clamp(0, 3),
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _insights[index].color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _insights[index].color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _insights[index].icon,
                        color: _insights[index].color,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _insights[index].title,
                              style: TextStyle(
                                color: Colors.grey[100],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _insights[index].description,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard(AppLocalizations l10n) {
    if (_weeklySummaries.isEmpty) {
      return const SizedBox.shrink();
    }

    final latestSummary = _weeklySummaries.first;

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whatWorkedThisWeek,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getEnergyIcon(latestSummary.averageEnergy.round()),
                  color: _getEnergyColor(latestSummary.averageEnergy.round()),
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.averageEnergy,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Text(
                        '${latestSummary.averageEnergy.toStringAsFixed(1)}/5',
                        style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (latestSummary.helpfulActivities.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.helpfulActivities,
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: latestSummary.helpfulActivities.map((activity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.green[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity,
                          style: TextStyle(
                            color: Colors.green[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            if (latestSummary.triggers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.activitiesToWatch,
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: latestSummary.triggers.map((trigger) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 14,
                          color: Colors.orange[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trigger,
                          style: TextStyle(
                            color: Colors.orange[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTriggersCard(AppLocalizations l10n) {
    if (_triggers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.triggerDetection,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              _triggers.length.clamp(0, 5),
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.red[400], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_triggers[index].activity} → ${_triggers[index].symptom}',
                              style: TextStyle(
                                color: Colors.grey[100],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Occurs within ${_triggers[index].avgHoursAfter.round()}h '
                              '(${_triggers[index].occurrenceCount}x)',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryTrendsCard(AppLocalizations l10n) {
    if (_recoveryTrends.isEmpty) {
      return const SizedBox.shrink();
    }

    final last14Days = _recoveryTrends.take(14).toList();

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recoveryTrends,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey[800], strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < last14Days.length) {
                            final date = last14Days[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value >= 1 && value <= 5) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  minX: 0,
                  maxX: (last14Days.length - 1).toDouble().clamp(
                    0,
                    double.infinity,
                  ),
                  minY: 0,
                  maxY: 5.5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        last14Days.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          last14Days[index].energyLevel,
                        ),
                      ),
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ADE80), Color(0xFF86EFAC)],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 4,
                              color: _getEnergyColor(
                                last14Days[index].energyLevel.round(),
                              ),
                              strokeWidth: 0,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4ADE80).withValues(alpha: 0.3),
                            const Color(0xFF4ADE80).withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEnergyIcon(int level) {
    switch (level) {
      case 1:
        return Icons.battery_alert;
      case 2:
        return Icons.battery_0_bar;
      case 3:
        return Icons.battery_2_bar;
      case 4:
        return Icons.battery_4_bar;
      case 5:
        return Icons.battery_full;
      default:
        return Icons.battery_0_bar;
    }
  }

  Color _getEnergyColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFFF87171);
      case 2:
        return const Color(0xFFFB923C);
      case 3:
        return const Color(0xFFFACC15);
      case 4:
        return const Color(0xFF86EFAC);
      case 5:
        return const Color(0xFF4ADE80);
      default:
        return const Color(0xFFFB923C);
    }
  }
}
