import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';
import 'package:technical_test/presentation/resources/resources.dart';

class RequestsContentView extends StatelessWidget {
  const RequestsContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white30,
      child: ListView(
        padding: const EdgeInsets.all(24.0), // Padding general del contenido
        children: const [
          // 1. Sección Superior (Volver, Título, Botón Nuevo)
          TopSection(),
          SizedBox(height: 10),

          // 2. Barra de Filtros/Búsqueda
          FilterBar(),
          SizedBox(height: 20),

          // 3. Tarjetas de Resumen
          SummaryCards(),
          SizedBox(height: 20),

          // 4. Área de la Tabla de Solicitudes
          _RequestsTableArea(),
          SizedBox(height: 20),

          // 5. Controles de Paginación
          _PaginationControls(),
        ],
      ),
    );
  }
}

// --- Widgets Internos de la Vista de Contenido ---

class _RequestsTableArea extends StatefulWidget {
  const _RequestsTableArea();

  @override
  State<_RequestsTableArea> createState() => _RequestsTableAreaState();
}

class _RequestsTableAreaState extends State<_RequestsTableArea> {
  // Estado para los tabs y la vista (lista/grid)
  int _selectedTabIndex = 0; // 0: Todas, 1: Pendientes, etc.
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: Título y Acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Listado de Solicitudes',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  // Botón Filtrar por Fecha
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.calendarDays, size: 16),
                    label: const Text('Filtrar por fecha'),
                    onPressed: () {
                      /* TODO: Mostrar Date Picker */
                    },
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
                  // Botón Descargar
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.download, size: 16),
                    label: const Text('Descargar'),
                    onPressed: () {
                      /* TODO: Implementar descarga */
                    },
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
                  // Toggle Vista Lista/Grid
                  ToggleButtons(
                    isSelected: [_isListView, !_isListView],
                    onPressed: (index) {
                      setState(() {
                        _isListView = index == 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    constraints: const BoxConstraints(
                      minHeight: 36,
                      minWidth: 36,
                    ), // Tamaño botones
                    selectedColor:
                        AppColors.primaryPurple, // Color icono seleccionado
                    color: Colors.grey.shade600, // Color icono no seleccionado
                    fillColor: AppColors.primaryPurple.withOpacity(
                      0.1,
                    ), // Fondo seleccionado
                    children: const [
                      Icon(LucideIcons.list, size: 18),
                      Icon(LucideIcons.layoutGrid, size: 18),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tabs de Filtro Rápido
          _buildFilterTabs(),
          const Divider(
            height: 20,
            thickness: 1,
          ), // Separador antes de la tabla
          // La Tabla de Datos (o Grid si _isListView es false)
          _buildDataTable(), // Por ahora solo implementamos la tabla
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final List<String> tabs = [
      'Todas',
      'Pendientes',
      'Aprobadas',
      'Rechazadas',
    ];
    return Wrap(
      // Usamos Wrap por si no caben en pantallas pequeñas
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(tabs.length, (index) {
        final bool isSelected = _selectedTabIndex == index;
        return ChoiceChip(
          label: Text(tabs[index]),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedTabIndex = index;
                // TODO: Aplicar filtro basado en el tab seleccionado
              });
            }
          },
          labelStyle: TextStyle(
            fontSize: 13,
            color: isSelected ? AppColors.primaryPurple : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          selectedColor: AppColors.primaryPurple.withOpacity(0.1),
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordes más redondeados
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          showCheckmark: false, // No mostrar checkmark
        );
      }),
    );
  }

  Widget _buildDataTable() {
    // Envolvemos con SingleChildScrollView para scroll horizontal si es necesario
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0, // Espacio entre columnas
        headingRowHeight: 40.0, // Altura fila cabecera
        dataRowMinHeight:
            58.0, // Altura mínima fila datos (ajustar según contenido)
        dataRowMaxHeight: 68.0, // Altura máxima
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
          fontSize: 13,
        ),
        dataTextStyle: const TextStyle(fontSize: 13, color: Colors.black87),
        columns: const [
          DataColumn(label: Text('Código')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Empleado')),
          DataColumn(label: Text('Período')),
          DataColumn(label: Text('Empresa/Sucursal')),
          DataColumn(label: Text('Solicitado:')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: dummyRequests.map((request) => _buildDataRow(request)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(RequestData request) {
    return DataRow(
      cells: [
        DataCell(Text(request.code)),
        DataCell(
          _buildTypeCell(request.typeIcon, request.type, request.typeDate),
        ),
        DataCell(
          _buildEmployeeCell(
            request.employeeName,
            request.employeeCode,
            request.employeeDept,
          ),
        ),
        DataCell(Text(request.period)),
        DataCell(_buildCompanyCell(request.company, request.branch)),
        DataCell(Text(request.requestedAgo)),
        DataCell(_StatusBadge(status: request.status)),
        DataCell(_buildActionsCell()),
      ],
    );
  }

  Widget _buildTypeCell(IconData icon, String type, String date) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
          child: Icon(icon, size: 16, color: AppColors.primaryPurple),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              date,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeCell(String name, String code, String dept) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(code, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        Text(dept, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildCompanyCell(String company, String branch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(company, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          branch,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActionsCell() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            /* TODO: Ver detalles */
          },

          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero, // Para quitar padding extra
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // Menor área de tap
            visualDensity: VisualDensity.compact,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ver detalles',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.arrowRight,
                size: 14,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          child: const Icon(LucideIcons.plus, size: 16),
          onPressed: () {
            /* TODO: Acción adicional */
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(30, 30), // Botón cuadrado pequeño
            padding: EdgeInsets.zero,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            foregroundColor: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// Widget reutilizable para las etiquetas de estado
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Pendiente':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'Aprobada':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Rechazada':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Chip(
      label: Text(status),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      side: BorderSide.none, // Sin borde
      visualDensity: VisualDensity.compact, // Más compacto
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Info Mostrando
        Text(
          'Mostrando 1-10 de 17 resultados', // TODO: Usar datos reales
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),

        // Controles
        Row(
          children: [
            Text(
              'Filas por página:', // TODO: Usar datos reales
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            // Dropdown Filas por página (Placeholder)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: 10, // TODO: Usar valor real
                  items:
                      [10, 25, 50].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value',
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                  onChanged: (int? newValue) {
                    // TODO: Cambiar filas por página
                  },
                  isDense: true, // Compacto
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  icon: const Icon(LucideIcons.chevronDown, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Botones de Paginación
            _buildPaginationButton(
              context,
              LucideIcons.chevronsLeft,
              onPressed: () {
                /* TODO: Primera página */
              },
              tooltip: 'Primera página',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronLeft,
              onPressed: () {
                /* TODO: Página anterior */
              },
              tooltip: 'Página anterior',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronRight,
              onPressed: () {
                /* TODO: Página siguiente */
              },
              tooltip: 'Página siguiente',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsRight,
              onPressed: () {
                /* TODO: Última página */
              },
              tooltip: 'Última página',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    // TODO: Deshabilitar botones si es necesario (primera/última página)
    final bool disabled = onPressed == null;
    final Color iconColor =
        disabled ? Colors.grey.shade400 : Colors.grey.shade700;

    return IconButton(
      icon: Icon(icon, size: 18),
      color: iconColor,
      onPressed: onPressed,
      tooltip: tooltip,
      splashRadius: 18,
      constraints: const BoxConstraints(
        minWidth: 30,
        minHeight: 30,
      ), // Tamaño consistente
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
