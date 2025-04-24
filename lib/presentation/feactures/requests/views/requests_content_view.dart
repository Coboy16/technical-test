import 'package:flutter/material.dart';

import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';

class RequestsContentView extends StatelessWidget {
  const RequestsContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white30,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
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
          RequestsTableArea(),
          SizedBox(height: 20),

          // 5. Controles de Paginación
          PaginationControls(),
        ],
      ),
    );
  }
}
