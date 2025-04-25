import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart'; // Asegúrate de tener esta dependencia

class RequestTypeOption {
  final IconData icon;
  final String title;
  final String description;
  final String typeId;

  const RequestTypeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.typeId,
  });
}

final List<RequestTypeOption> _requestOptions = [
  const RequestTypeOption(
    icon: LucideIcons.umbrella,
    title: 'Vacaciones',
    description: 'Solicitud de días libres remunerados',
    typeId: 'vacation',
  ),
  const RequestTypeOption(
    icon: LucideIcons.calendarDays,
    title: 'Permiso',
    description: 'Solicitud para ausentarse por tiempo limitado',
    typeId: 'permit',
  ),
  const RequestTypeOption(
    icon: LucideIcons.stethoscope,
    title: 'Licencia Médica',
    description: 'Ausencia por motivos de salud',
    typeId: 'medical',
  ),
  const RequestTypeOption(
    icon: LucideIcons.clock,
    title: 'Suspensión',
    description: 'Solicitud de suspensión temporal',
    typeId: 'suspension',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.alarmClock,
    title: 'Cambio de Horario',
    description: 'Modificación de horario laboral',
    typeId: 'schedule_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.repeat,
    title: 'Cambio de Posición',
    description: 'Solicitud de transferencia o cambio de puesto',
    typeId: 'position_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.coins,
    title: 'Cambio de Propina',
    description: 'Ajuste en la distribución de propinas',
    typeId: 'tip_change',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.creditCard,
    title: 'Avances',
    description: 'Solicitud de avance o adelanto de salario',
    typeId: 'advance',
  ),
  const RequestTypeOption(
    icon: LucideIcons.mail,
    title: 'Cartas',
    description: 'Solicitud de documentos oficiales',
    typeId: 'letter',
  ),
  const RequestTypeOption(
    icon: LucideIcons.shirt,
    title: 'Uniforme',
    description: 'Solicitud de uniforme de trabajo',
    typeId: 'uniform',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.house,
    title: 'Cambio de Alojamiento',
    description: 'Solicitud de cambio de alojamiento',
    typeId: 'housing_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.userMinus,
    title: 'Salida',
    description: 'Solicitud de salida o terminación de contrato',
    typeId: 'exit',
  ), // Icono aproximado
];

class SelectRequestTypeDialog extends StatelessWidget {
  const SelectRequestTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Ajusta el número de columnas según el ancho disponible
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        (screenWidth < 600) ? 2 : (screenWidth < 900 ? 3 : 4);
    const double cardAspectRatio =
        1.5; // Ajusta esto para la proporción alto/ancho de las tarjetas

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor:
          Colors.white, // Evita tinte de Material 3 si usas tema M3
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      insetPadding: const EdgeInsets.all(20.0), // Margen alrededor del dialog
      child: ConstrainedBox(
        // Limita el tamaño máximo del diálogo
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 600,
        ), // Ajusta según necesites
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Para que la columna se ajuste al contenido
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fila del Título y Botón Cerrar ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecciona el tipo de solicitud',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Elige el tipo de solicitud que deseas crear',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        () => Navigator.of(context).pop(), // Cierra el diálogo
                    tooltip: 'Cerrar',
                    splashRadius: 20,
                    color: Colors.black54,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Usamos Expanded para que el GridView ocupe el espacio restante
              Expanded(
                child: GridView.builder(
                  shrinkWrap:
                      true, // Necesario dentro de Column con Expanded a veces
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0, // Espacio horizontal entre tarjetas
                    mainAxisSpacing: 16.0, // Espacio vertical entre tarjetas
                    childAspectRatio: cardAspectRatio, // Proporción ancho/alto
                  ),
                  itemCount: _requestOptions.length,
                  itemBuilder: (context, index) {
                    return _buildOptionCard(context, _requestOptions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, RequestTypeOption option) {
    final Color iconColor = Colors.blue.shade400;

    return InkWell(
      onTap: () {
        print('Opción seleccionada: ${option.title} (ID: ${option.typeId})');
        Navigator.of(context).pop(option.typeId); // Devuelve el ID al cerrar
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(option.icon, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  // Para que el texto no se desborde si es largo
                  child: Text(
                    option.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600, // Semi-bold
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis, // Evita desbordamiento
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              option.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),

              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
