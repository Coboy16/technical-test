import 'package:flutter/material.dart';
import 'package:technical_test/presentation/feactures/requests/views/views.dart';
import 'package:technical_test/presentation/widgets/sidebar/sidebar_widget.dart';
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
                Expanded(child: RequestsContentView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
