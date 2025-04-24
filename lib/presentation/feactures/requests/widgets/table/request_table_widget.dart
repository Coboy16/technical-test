import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';
import 'package:technical_test/presentation/resources/resources.dart';

class RequestsTableArea extends StatefulWidget {
  const RequestsTableArea({super.key});

  @override
  State<RequestsTableArea> createState() => _RequestsTableAreaState();
}

class _RequestsTableAreaState extends State<RequestsTableArea> {
  int _selectedTabIndex = 0; // 0: Todas, 1: Pendientes, etc.
  bool _isListView = true;

  // Lista filtrada de solicitudes (sin cambios)
  List<RequestData> get _filteredRequests {
    if (_selectedTabIndex == 0) {
      return dummyRequests; // Todas
    } else if (_selectedTabIndex == 1) {
      return dummyRequests.where((req) => req.status == 'Pendiente').toList();
    } else if (_selectedTabIndex == 2) {
      return dummyRequests.where((req) => req.status == 'Aprobada').toList();
    } else {
      return dummyRequests.where((req) => req.status == 'Rechazada').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadiusValue = 8.0;
    const BorderRadius borderRadius = BorderRadius.all(
      Radius.circular(borderRadiusValue),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado y filtros (siempre visibles)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Listado de Solicitudes',
                  style: AppTextStyles.titleSolicitudes,
                ),
                const SizedBox(height: 16),
                // Filtros y cambio de vista
                FilterHeaderWidget(
                  initialTabIndex: _selectedTabIndex,
                  initialListView: _isListView,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  onViewChanged: (isListView) {
                    setState(() {
                      _isListView = isListView;
                    });
                  },
                  onFilterByDate: () {},
                  onDownload: () {},
                ),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: const BorderRadius.only(
              // Solo redondear esquinas inferiores
              bottomLeft: Radius.circular(borderRadiusValue),
              bottomRight: Radius.circular(borderRadiusValue),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                16.0,
              ), // Padding para tabla/grid
              child: _isListView ? _buildDataTableView() : _buildCardsView(),
            ),
          ),
        ],
      ),
    );
  }

  // --- Vista de Tabla ---
  Widget _buildDataTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 25.0,
        headingRowHeight: 40.0,
        dataRowMinHeight: 58.0,
        dataRowMaxHeight: 68.0,
        headingRowColor: WidgetStateProperty.all(
          Colors.grey.shade50,
        ), // Fondo cabecera
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
          fontSize: 13,
        ),
        dataTextStyle: const TextStyle(fontSize: 13, color: Colors.black),
        border: TableBorder.all(
          color: Colors.grey.shade200,
          width: 1,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          style: BorderStyle.none, //comentar esta línea para mostrar bordes
        ),
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
        rows:
            _filteredRequests.map((request) => _buildDataRow(request)).toList(),
      ),
    );
  }

  // --- Vista de Tarjetas (Grid/Lista) ---
  Widget _buildCardsView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int crossAxisCount =
            availableWidth > 1200
                ? 3
                : availableWidth > 800
                ? 2
                : 1;

        return crossAxisCount > 1
            ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                // childAspectRatio: 1.0, // Ajusta si es necesario
                mainAxisExtent: 380, // Altura fija de las tarjetas
              ),
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  request: _filteredRequests[index],
                  onViewDetails: () {},
                  onActionSelected: (action) {},
                );
              },
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _filteredRequests.length - 1 ? 0 : 16.0,
                  ),
                  child: RequestCard(
                    request: _filteredRequests[index],
                    onViewDetails: () {
                      /* TODO */
                    },
                    onActionSelected: (action) {
                      /* TODO */
                    },
                  ),
                );
              },
            );
      },
    );
  }

  DataRow _buildDataRow(RequestData request) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return null;
      }),
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
        DataCell(StatusBadge(status: request.status)),
        DataCell(_buildActionsCell(request)),
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

  Widget _buildActionsCell(RequestData request) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            /* TODO: Ver detalles */
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(LucideIcons.plus, size: 16, color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          itemBuilder:
              (context) => [
                _buildMenuItem(
                  icon: LucideIcons.squarePen,
                  text: 'Editar solicitud',
                  textColor: Colors.black87,
                ),
                _buildMenuItem(
                  icon: LucideIcons.download,
                  text: 'Descargar PDF',
                  textColor: Colors.black87,
                ),
                _buildMenuItem(
                  icon: LucideIcons.circleCheckBig,
                  text: 'Aprobar solicitud',
                  textColor: AppColors.primaryPurple,
                ),
                _buildMenuItem(
                  icon: LucideIcons.circleX,
                  text: 'Rechazar solicitud',
                  textColor: Colors.red,
                ),
              ],
          onSelected: (value) {
            /* TODO: Manejar acción */
          },
          offset: const Offset(0, 30),
          elevation: 2,
        ),
      ],
    );
  }

  // Helper para construir los items del menú (sin cambios)
  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String text,
    required Color textColor,
  }) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: textColor)),
        ],
      ),
    );
  }
}
