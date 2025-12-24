import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumora/l10n/app_localizations.dart';
import '../models/energy_entry.dart';
import '../services/storage_service.dart';

class EnergyTrackerScreen extends StatefulWidget {
  const EnergyTrackerScreen({super.key});

  @override
  State<EnergyTrackerScreen> createState() => _EnergyTrackerScreenState();
}

class _EnergyTrackerScreenState extends State<EnergyTrackerScreen> {
  final StorageService _storageService = StorageService();
  List<EnergyEntry> _entries = [];
  int? _selectedEnergyLevel;
  final List<String> _activities = [];
  final TextEditingController _activityController = TextEditingController();
  bool _isLoading = true;
  bool _showHistory = false;
  int _currentStep = 0;
  final List<String> _selectedSymptoms = [];

  final List<IconData> _energyIcons = [
    Icons.battery_alert,
    Icons.battery_0_bar,
    Icons.battery_2_bar,
    Icons.battery_4_bar,
    Icons.battery_full,
  ];

  final List<Color> _energyColors = [
    const Color(0xFFF87171),
    const Color(0xFFFB923C),
    const Color(0xFFFACC15),
    const Color(0xFF86EFAC),
    const Color(0xFF4ADE80),
  ];

  final List<String> _symptoms = [
    'fatigue',
    'brain fog',
    'dizziness',
    'pain',
    'headache',
    'nausea',
    'shortness of breath',
    'chest pain',
    'muscle weakness',
    'joint pain',
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _storageService.getEntries();
    if (mounted) {
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_selectedEnergyLevel == null) return;

    final entry = EnergyEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      energyLevel: _selectedEnergyLevel!,
      activities: List.from(_activities),
      symptoms: List.from(_selectedSymptoms),
    );

    await _storageService.saveEntry(entry);
    await _loadEntries();

    if (mounted) {
      setState(() {
        _selectedEnergyLevel = null;
        _activities.clear();
        _activityController.clear();
        _selectedSymptoms.clear();
        _currentStep = 0;
        _showHistory = true;
      });
    }
  }

  void _addActivity() {
    final text = _activityController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _activities.add(text);
        _activityController.clear();
      });
    }
  }

  void _removeActivity(int index) {
    setState(() {
      _activities.removeAt(index);
    });
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> _deleteEntry(String id) async {
    await _storageService.deleteEntry(id);
    await _loadEntries();
  }

  void _showNewEntry() {
    setState(() {
      _selectedEnergyLevel = null;
      _activities.clear();
      _activityController.clear();
      _selectedSymptoms.clear();
      _currentStep = 0;
      _showHistory = false;
    });
  }

  List<String> _getUniqueActivities() {
    final Set<String> uniqueActivities = {};
    for (final entry in _entries) {
      for (final activity in entry.activities) {
        uniqueActivities.add(activity);
      }
    }
    return uniqueActivities.toList()..sort();
  }

  String _getStepTitle(int step) {
    final l10n = AppLocalizations.of(context)!;
    switch (step) {
      case 0:
        return l10n.energyTitle;
      case 1:
        return l10n.activitiesTitle;
      case 2:
        return l10n.symptomsTitle;
      default:
        return '';
    }
  }

  Widget _buildStepContent(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildEnergyStep(l10n);
      case 1:
        return _buildActivitiesStep(l10n);
      case 2:
        return _buildSymptomsStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEnergyStep(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.energyTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey[100],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...List.generate(5, (index) {
            final level = index + 1;
            final isSelected = _selectedEnergyLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEnergyLevel = level;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _energyColors[index].withValues(alpha: 0.2)
                        : const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? _energyColors[index]
                          : Colors.grey[800]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _energyIcons[index],
                        color: _energyColors[index],
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _getEnergyLabel(level),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.grey[100],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: _energyColors[index],
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivitiesStep(AppLocalizations l10n) {
    final uniqueActivities = _getUniqueActivities();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.activitiesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[300]),
          ),
          const SizedBox(height: 12),
          if (uniqueActivities.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: uniqueActivities.map((activity) {
                final isSelected = _activities.contains(activity);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _activities.remove(activity);
                      } else {
                        _activities.add(activity);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF374151)
                          : const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue[400]!
                            : Colors.grey[700]!,
                      ),
                    ),
                    child: Text(
                      activity,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _activityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.newActivity,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (_) => _addActivity(),
                  ),
                ),
                Container(height: 48, width: 1, color: Colors.grey[800]),
                IconButton(
                  onPressed: _addActivity,
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.grey[400],
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          if (_activities.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.selectActivities,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_activities.length, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[400]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _activities[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _removeActivity(index),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomsStep(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.symptomsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[300]),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _symptoms.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return GestureDetector(
                onTap: () => _toggleSymptom(symptom),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.withValues(alpha: 0.2)
                        : const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.red[400]! : Colors.grey[700]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    symptom,
                    style: TextStyle(
                      color: isSelected ? Colors.red[300] : Colors.grey[300],
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              '${_selectedSymptoms.length} ${l10n.symptomsHint}',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[700]!),
                    ),
                    child: Text(l10n.back),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey[800],
                    disabledForegroundColor: Colors.grey[600],
                  ),
                  child: Text(
                    _currentStep == 2 ? l10n.saveEntry : l10n.next,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedEnergyLevel != null;
      case 1:
        return true;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _saveEntry();
    }
  }

  String _getEnergyLabel(int level) {
    final labels = [
      AppLocalizations.of(context)!.energyLevel1,
      AppLocalizations.of(context)!.energyLevel2,
      AppLocalizations.of(context)!.energyLevel3,
      AppLocalizations.of(context)!.energyLevel4,
      AppLocalizations.of(context)!.energyLevel5,
    ];
    return labels[level - 1];
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

    if (!_showHistory) {
      return Scaffold(
        backgroundColor: const Color(0xFF111827),
        appBar: AppBar(
          title: Text(
            _getStepTitle(_currentStep),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: _currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _selectedEnergyLevel != null &&
                          _selectedEnergyLevel! > 0 &&
                          _selectedEnergyLevel! <= _energyColors.length
                      ? _energyColors[_selectedEnergyLevel! - 1]
                      : Colors.grey.shade600,
                ),
              ),
              Expanded(child: _buildStepContent(l10n)),
              _buildNavigationButtons(l10n),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          l10n.historyTitle,
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
                  Icon(Icons.history, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noEntries,
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEnergyLevelChart(),
                  const SizedBox(height: 24),
                  _buildSymptomsChart(),
                  const SizedBox(height: 24),
                  _buildActivitiesChart(),
                  const SizedBox(height: 24),
                  _buildEntriesList(l10n),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewEntry,
        label: Text(l10n.saveEntry),
        icon: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildEnergyLevelChart() {
    final sortedEntries = List<EnergyEntry>.from(_entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final last7Days = sortedEntries.take(7).toList();

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Levels (Last 7 Entries)',
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
                              value.toInt() < last7Days.length) {
                            final date = last7Days[value.toInt()].date;
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
                  maxX: (last7Days.length - 1).toDouble().clamp(
                    0,
                    double.infinity,
                  ),
                  minY: 0,
                  maxY: 5.5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        last7Days.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          last7Days[index].energyLevel.toDouble(),
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
                              color:
                                  _energyColors[last7Days[index].energyLevel -
                                      1],
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

  Widget _buildSymptomsChart() {
    final symptomCounts = <String, int>{};
    for (final entry in _entries) {
      for (final symptom in entry.symptoms) {
        symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
      }
    }

    if (symptomCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedSymptoms = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSymptoms = sortedSymptoms.take(5).toList();

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Symptoms',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: topSymptoms.isEmpty
                      ? 1
                      : topSymptoms.first.value.toDouble() * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
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
                              value.toInt() < topSymptoms.length) {
                            final symptom = topSymptoms[value.toInt()].key;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                symptom.length > 10
                                    ? '${symptom.substring(0, 10)}...'
                                    : symptom,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 60,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value > 0) {
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
                  barGroups: List.generate(
                    topSymptoms.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: topSymptoms[index].value.toDouble(),
                          color: Colors.red.withValues(alpha: 0.7),
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesChart() {
    final activityCounts = <String, int>{};
    for (final entry in _entries) {
      for (final activity in entry.activities) {
        activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
      }
    }

    if (activityCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedActivities = activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topActivities = sortedActivities.take(5).toList();

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Activities',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: topActivities.isEmpty
                      ? 1
                      : topActivities.first.value.toDouble() * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
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
                              value.toInt() < topActivities.length) {
                            final activity = topActivities[value.toInt()].key;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                activity.length > 10
                                    ? '${activity.substring(0, 10)}...'
                                    : activity,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 60,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value > 0) {
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
                  barGroups: List.generate(
                    topActivities.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: topActivities[index].value.toDouble(),
                          color: Colors.blue.withValues(alpha: 0.7),
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Entries',
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_entries.length.clamp(0, 5), (index) {
          final entry = _entries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: const Color(0xFF1F2937),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _energyIcons[entry.energyLevel - 1],
                            color: _energyColors[entry.energyLevel - 1],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getEnergyLabel(entry.energyLevel),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(entry.date),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                  if (entry.activities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...entry.activities.map(
                      (activity) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                            Expanded(
                              child: Text(
                                activity,
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (entry.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: entry.symptoms
                          .map(
                            (symptom) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                symptom,
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _deleteEntry(entry.id),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(l10n.delete),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }
}
