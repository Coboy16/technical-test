import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';
import 'package:technical_test/presentation/resources/resources.dart';

class RequestCard extends StatelessWidget {
  final RequestData request;
  final VoidCallback? onViewDetails;
  final Function(String)? onActionSelected;

  const RequestCard({
    super.key,
    required this.request,
    this.onViewDetails,
    this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con tipo y estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // Icono y tipo
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
                      child: Icon(
                        request.typeIcon,
                        size: 16,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      request.type,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Estado
                StatusBadge(status: request.status),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, thickness: 1),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del empleado
                _buildInfoRow(
                  'Empleado:',
                  request.employeeName,
                  '(Código ${request.employeeCode})',
                ),
                _buildInfoRow('Departamento:', request.employeeDept, ''),
                _buildInfoRow('Fecha Solicitud:', request.typeDate, ''),
                _buildInfoRow('Período:', request.period, ''),
                _buildInfoRow('Empresa:', request.company, ''),
                _buildInfoRow('Sucursal:', request.branch, ''),
                _buildInfoRow('Solicitado:', request.requestedAgo, ''),
              ],
            ),
          ),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón Ver detalles
                OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(LucideIcons.arrowRight, size: 16),
                  label: const Text('Ver detalles'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                // Botón Acciones
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      LucideIcons.plus,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder:
                      (context) => [
                        _buildMenuItem(
                          LucideIcons.squarePen,
                          'Editar solicitud',
                          Colors.black87,
                        ),
                        _buildMenuItem(
                          LucideIcons.download,
                          'Descargar PDF',
                          Colors.black87,
                        ),
                        _buildMenuItem(
                          LucideIcons.circleCheckBig,
                          'Aprobar solicitud',
                          AppColors.primaryPurple,
                        ),
                        _buildMenuItem(
                          LucideIcons.circleX,
                          'Rechazar solicitud',
                          Colors.red,
                        ),
                      ],
                  onSelected: (value) {
                    if (onActionSelected != null) {
                      onActionSelected!(value);
                    }
                  },
                  offset: const Offset(0, 30),
                  elevation: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir filas de información
  Widget _buildInfoRow(String label, String value, String subvalue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subvalue.isNotEmpty)
                  Text(
                    subvalue,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir los items del menú
  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
