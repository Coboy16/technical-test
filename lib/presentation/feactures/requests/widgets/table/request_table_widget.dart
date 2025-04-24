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
                  _filteredRequests
                      .map((request) => _buildDataRow(request))
                      .toList(),
            ),
          ),
        );
      },
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
          child: Icon(icon, size: 16, color: Colors.blueAccent.shade700),
        ),
        const SizedBox(width: 10),
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
                // Mostrar flujo de aprobación con datos estáticos
                _showApprovalFlow(context, request);
                break;

              case 'Rechazar solicitud':
                // Mostrar flujo de rechazo con datos estáticos
                _showRejectionFlow(context, request);
                break;
            }
          },
          offset: const Offset(0, 30),
          elevation: 2,
        ),
      ],
    );
  }

  //TODO: mejorar
  void _showApprovalFlow(BuildContext context, RequestData request) {
    // Paso 1: Mostrar modal de aprobación
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ApproveRequestModalWidget(
          request: request,
          onApprove: (comments) {
            // Cerrar el primer modal
            Navigator.of(context).pop();

            // Paso 2: Mostrar confirmación
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModalWidget(
                  message:
                      '¿Está completamente seguro de que desea aprobar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: Colors.green,
                  confirmButtonText: 'Confirmar',
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    // Cerrar modal de confirmación
                    Navigator.of(context).pop();

                    // Paso 3: Mostrar resultado exitoso
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SuccessResultModalWidget(
                          title: 'Aprobación exitosa',
                          message:
                              'La solicitud ha sido aprobada correctamente.',
                          iconColor: Colors.green,
                          onAccept: () {
                            Navigator.of(context).pop();
                            // Mostrar mensaje de confirmación
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Solicitud de ${request.employeeName} aprobada',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Función simplificada para mostrar el flujo de rechazo
  void _showRejectionFlow(BuildContext context, RequestData request) {
    // Paso 1: Mostrar modal de rechazo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RejectRequestModalWidget(
          request: request,
          onReject: (reason) {
            // Cerrar el primer modal
            Navigator.of(context).pop();

            // Paso 2: Mostrar confirmación
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModalWidget(
                  message:
                      '¿Está completamente seguro de que desea rechazar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: Colors.red,
                  confirmButtonText: 'Confirmar',
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    // Cerrar modal de confirmación
                    Navigator.of(context).pop();

                    // Paso 3: Mostrar resultado exitoso
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SuccessResultModalWidget(
                          title: 'Rechazo exitoso',
                          message:
                              'La solicitud ha sido rechazada correctamente.',
                          iconColor: Colors.red,
                          onAccept: () {
                            Navigator.of(context).pop();
                            // Mostrar mensaje de confirmación
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Solicitud de ${request.employeeName} rechazada',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
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
