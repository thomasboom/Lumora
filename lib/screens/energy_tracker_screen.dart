import 'package:flutter/material.dart';
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

  final List<IconData> _energyIcons = [
    Icons.battery_alert,
    Icons.battery_0_bar,
    Icons.battery_2_bar,
    Icons.battery_4_bar,
    Icons.battery_full,
  ];

  final List<Color> _energyColors = [
    Colors.red[400]!,
    Colors.orange[400]!,
    Colors.yellow[400]!,
    Colors.lightGreen[400]!,
    Colors.green[400]!,
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
    );

    await _storageService.saveEntry(entry);
    await _loadEntries();

    if (mounted) {
      setState(() {
        _selectedEnergyLevel = null;
        _activities.clear();
        _activityController.clear();
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

  Future<void> _deleteEntry(String id) async {
    await _storageService.deleteEntry(id);
    await _loadEntries();
  }

  void _showNewEntry() {
    setState(() {
      _selectedEnergyLevel = null;
      _activities.clear();
      _activityController.clear();
      _showHistory = false;
    });
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                const SizedBox(height: 24),
                Text(
                  l10n.activitiesTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[300]),
                ),
                const SizedBox(height: 12),
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
                            hintText: l10n.activityHint,
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
                  const SizedBox(height: 12),
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
                          border: Border.all(color: Colors.grey[700]!),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedEnergyLevel != null ? _saveEntry : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                    child: Text(
                      l10n.saveEntry,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_entries.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showHistory = true;
                      });
                    },
                    child: Text(
                      l10n.historyTitle,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ],
            ),
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
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
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
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
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
              },
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

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }
}
