import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';

class FilterHeaderWidget extends StatefulWidget {
  final int initialTabIndex;
  final bool initialListView;
  final Function(int) onTabChanged;
  final Function(bool) onViewChanged;
  final VoidCallback? onFilterByDate;
  final VoidCallback? onDownload;

  const FilterHeaderWidget({
    super.key,
    this.initialTabIndex = 0,
    this.initialListView = true,
    required this.onTabChanged,
    required this.onViewChanged,
    this.onFilterByDate,
    this.onDownload,
  });

  @override
  State<FilterHeaderWidget> createState() => _FilterHeaderWidgetState();
}

class _FilterHeaderWidgetState extends State<FilterHeaderWidget> {
  late int _selectedTabIndex;
  late bool _isListView;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _isListView = widget.initialListView;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'Todas',
      'Pendientes',
      'Aprobadas',
      'Rechazadas',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 768;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Panel de tabs (izquierda)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(tabs.length, (index) {
                  final bool isSelected = _selectedTabIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                        widget.onTabChanged(index);
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              isSelected
                                  ? AppColors.primaryPurple
                                  : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Si no es pantalla ancha, mostrar solo los botones más importantes
            if (!isWideScreen && constraints.maxWidth < 600)
              Row(
                children: [
                  // Botón de menú con opciones adicionales
                  IconButton(
                    icon: Icon(LucideIcons.menu, color: Colors.grey.shade700),
                    onPressed: () {
                      // TODO: Mostrar menú con opciones de filtro y descarga
                    },
                  ),
                  // Botones de alternancia de vista
                  ToggleButtons(
                    isSelected: [_isListView, !_isListView],
                    onPressed: (index) {
                      setState(() {
                        _isListView = index == 0;
                        widget.onViewChanged(_isListView);
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    constraints: const BoxConstraints(
                      minHeight: 36,
                      minWidth: 36,
                    ),
                    selectedColor: AppColors.primaryPurple,
                    color: Colors.grey.shade600,
                    fillColor: AppColors.primaryPurple.withOpacity(0.1),
                    children: const [
                      Icon(LucideIcons.list, size: 18),
                      Icon(LucideIcons.layoutGrid, size: 18),
                    ],
                  ),
                ],
              )
            else
              // Todos los botones de acción en pantallas medianas y grandes
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.calendarDays, size: 16),
                    label: const Text('Filtrar por fecha'),
                    onPressed: widget.onFilterByDate,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.download, size: 16),
                    label: const Text('Descargar'),
                    onPressed: widget.onDownload,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ToggleButtons(
                    isSelected: [_isListView, !_isListView],
                    onPressed: (index) {
                      setState(() {
                        _isListView = index == 0;
                        widget.onViewChanged(_isListView);
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    constraints: const BoxConstraints(
                      minHeight: 36,
                      minWidth: 36,
                    ),
                    selectedColor: AppColors.primaryPurple,
                    color: Colors.grey.shade600,
                    fillColor: AppColors.primaryPurple.withOpacity(0.1),
                    children: const [
                      Icon(LucideIcons.list, size: 18),
                      Icon(LucideIcons.layoutGrid, size: 18),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
