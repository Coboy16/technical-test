import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/feactures/requests/blocs/blocs.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/utils/utils.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Cargar las solicitudes iniciales en el bloc
    context.read<RequestFilterBloc>().add(LoadInitialRequests(dummyRequests));
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    // Puedes pasar las fechas actuales si ya hay alguna seleccionada
    final picked = await showDialog<DateTimeRange>(
      // Espera un DateTimeRange si habilitas la devolución
      context: context,
      builder: (BuildContext context) {
        // Pasa las fechas seleccionadas actuales al popup
        return DateRangePickerPopup(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          // Puedes forzar el mes inicial si quieres
          // initialMonth: DateTime(2025, 4),
        );
      },
    );

    // --- Procesar el resultado (si habilitas la devolución de datos) ---
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        print('Rango seleccionado: $_startDate - $_endDate');
        // Aquí actualizarías tu UI o harías lo que necesites con las fechas
      });
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
                    // Enviar evento de cambio de tab al bloc
                    context.read<RequestFilterBloc>().add(
                      StatusTabChanged(index),
                    );
                  },
                  onViewChanged: (isListView) {
                    setState(() {
                      _isListView = isListView;
                    });
                  },
                  onFilterByDate: () {
                    _showDateRangePicker(context);
                  },
                  onDownload: () {},
                ),
              ],
            ),
          ),

          // Usamos BlocBuilder para reconstruir esta parte cuando cambia el estado del filtro
          BlocBuilder<RequestFilterBloc, RequestFilterState>(
            builder: (context, state) {
              return ClipRRect(
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
                  child:
                      _isListView
                          ? _buildDataTableView(state.filteredRequests)
                          : _buildCardsView(state.filteredRequests),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Vista de Tabla ---
  Widget _buildDataTableView(List<RequestData> requests) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 25.0,
              headingRowHeight: 40.0,
              dataRowMinHeight: 58.0,
              dataRowMaxHeight: 68.0,
              headingRowColor: WidgetStateProperty.all(
                Colors.grey.withOpacity(0.03),
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
                style:
                    BorderStyle.none, //comentar esta línea para mostrar bordes
              ),
              columns: [
                DataColumn(
                  label: Text('Código', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text('Tipo', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text('Empleado', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text('Período', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text(
                    'Empresa/Sucursal',
                    style: AppTextStyles.titleColum,
                  ),
                ),
                DataColumn(
                  label: Text('Solicitado:', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text('Estado', style: AppTextStyles.titleColum),
                ),
                DataColumn(
                  label: Text('Acciones', style: AppTextStyles.titleColum),
                ),
              ],
              rows: requests.map((request) => _buildDataRow(request)).toList(),
            ),
          ),
        );
      },
    );
  }

  // --- Vista de Tarjetas (Grid/Lista) ---
  Widget _buildCardsView(List<RequestData> requests) {
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
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  request: requests[index],
                  onViewDetails: () {},
                  onActionSelected: (action) {},
                );
              },
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == requests.length - 1 ? 0 : 16.0,
                  ),
                  child: RequestCard(
                    request: requests[index],
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
        DataCell(Text(request.code, style: AppTextStyles.subtitleColum)),
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
        DataCell(Text(request.period, style: AppTextStyles.subtitleColum)),
        DataCell(_buildCompanyCell(request.company, request.branch)),
        DataCell(
          Text(request.requestedAgo, style: AppTextStyles.subtitleColum),
        ),
        DataCell(StatusBadge(status: request.status)),
        DataCell(_buildActionsCell(request)),
      ],
    );
  }

  //vacaciones
  Widget _buildTypeCell(IconData icon, String type, String date) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
          child: Icon(icon, size: 18, color: Colors.blueAccent.shade700),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(type, style: AppTextStyles.titleColum),
            Text(date, style: AppTextStyles.subtitleColum),
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
        Text(name, style: AppTextStyles.titleColum),
        Text(code, style: AppTextStyles.subtitleColum),
        Text(dept, style: AppTextStyles.subtitleColum),
      ],
    );
  }

  Widget _buildCompanyCell(String company, String branch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(company, style: AppTextStyles.titleColumTwo),
        Text(branch, style: AppTextStyles.subtitleColum),
      ],
    );
  }

  Widget _buildActionsCell(RequestData request) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            /* TODO: Ver detalles */
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
              color: const Color.fromARGB(36, 192, 189, 189),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ver detalles',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                const SizedBox(width: 4),
                Icon(LucideIcons.arrowRight, size: 14, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          color: Colors.white,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
              color: const Color.fromARGB(36, 192, 189, 189),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(LucideIcons.plus, size: 16, color: Colors.black),
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
            // Manejar las acciones seleccionadas del menú
            switch (value) {
              case 'Editar solicitud':
                // Simplemente mostrar un mensaje para el prototipo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editar solicitud ${request.code}')),
                );
                break;

              case 'Descargar PDF':
                // Mostrar diálogo de descarga simulada
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("Generando PDF..."),
                        ],
                      ),
                    );
                  },
                );

                // Simular descarga con un retraso
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop(); // Cerrar diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('PDF descargado correctamente'),
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  );
                });
                break;

              case 'Aprobar solicitud':
                // Mostrar flujo de aprobación
                showApprovalFlow(context, request);
                break;

              case 'Rechazar solicitud':
                showRejectionFlow(context, request);
                break;
            }
          },
          offset: const Offset(0, 30),
          elevation: 2,
        ),
      ],
    );
  }

  // Helper para construir los items del menú
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
