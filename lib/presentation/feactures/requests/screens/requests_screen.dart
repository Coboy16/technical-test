import 'package:flutter/material.dart';
import 'package:technical_test/presentation/widgets/widgets.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No usamos el appBar del Scaffold directamente para tener más control
      // en la disposición con el Row principal.
      body: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start, // Alinea los hijos al inicio verticalmente
        children: [
          // --- Sidebar a la izquierda ---
          const SidebarWidget(),

          // --- Contenido Principal a la derecha ---
          Expanded(
            child: Column(
              children: [
                // --- Header en la parte superior del contenido ---
                const HeaderWidget(),

                // --- Área de contenido principal (Aquí irá el resto) ---
                Expanded(
                  child: SingleChildScrollView(
                    // Para permitir scroll si el contenido es largo
                    padding: const EdgeInsets.all(
                      24.0,
                    ), // Añade padding general al contenido
                    child: Center(
                      child: Column(
                        // Aquí irá el contenido específico de "Solicitudes"
                        // (Cards de resumen, filtros, tabla, etc.)
                        children: [
                          Text('Contenido Principal de Solicitudes Aquí'),
                          // TODO: Añadir el resto de la interfaz (cards, filtros, tabla)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
