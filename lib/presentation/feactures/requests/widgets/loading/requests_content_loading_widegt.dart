import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RequestsContentShimmer extends StatelessWidget {
  const RequestsContentShimmer({super.key});

  // Colores base para el shimmer (ajusta si quieres otro tono)
  static final Color _shimmerBaseColor = Colors.grey[300]!;
  static final Color _shimmerHighlightColor = Colors.grey[100]!;

  // Helper para crear contenedores placeholder
  Widget _buildPlaceholder({
    double? height,
    double? width,
    double radius = 4.0,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white, // El color base del shimmer lo sobreescribirá
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(radius) : null,
        shape: shape,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aplica el efecto shimmer a todo el contenido del placeholder
    return Shimmer.fromColors(
      baseColor: _shimmerBaseColor,
      highlightColor: _shimmerHighlightColor,
      period: const Duration(milliseconds: 1200), // Duración de la animación
      child: SingleChildScrollView(
        // Para permitir scroll si el contenido es largo
        physics:
            const NeverScrollableScrollPhysics(), // Deshabilitar scroll en shimmer
        padding: const EdgeInsets.all(
          24.0,
        ), // Padding similar al contenido real
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Shimmer para el Header (Volver, Título, Botón) ---
            _buildShimmerHeader(),
            const SizedBox(height: 24),

            // --- Shimmer para la barra de filtros ---
            _buildShimmerFilterBar(),
            const SizedBox(height: 24),

            // --- Shimmer para las tarjetas de resumen ---
            _buildShimmerSummaryCards(),
            const SizedBox(height: 24),

            // --- Shimmer para el contenedor de la tabla ---
            _buildShimmerTableContainer(),
          ],
        ),
      ),
    );
  }

  // --- Placeholders específicos para cada sección ---

  Widget _buildShimmerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlaceholder(height: 14, width: 80), // "<- Volver"
            const SizedBox(height: 8),
            _buildPlaceholder(height: 20, width: 150), // Título "Solicitudes"
            const SizedBox(height: 4),
            _buildPlaceholder(height: 14, width: 250), // Subtítulo
          ],
        ),
        _buildPlaceholder(
          height: 40,
          width: 160,
          radius: 8,
        ), // Botón "+ Nueva Solicitud"
      ],
    );
  }

  Widget _buildShimmerFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo para que se vea el shimmer
        borderRadius: BorderRadius.circular(8),
        // Simula el borde si lo tiene el contenedor real
        // border: Border.all(color: Colors.grey.shade200)
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildPlaceholder(height: 40, radius: 8),
          ), // Search bar
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: _buildPlaceholder(height: 40, radius: 8),
          ), // Dropdown 1
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: _buildPlaceholder(height: 40, radius: 8),
          ), // Dropdown 2
          const SizedBox(width: 16),
          _buildPlaceholder(
            height: 40,
            width: 40,
            radius: 8,
          ), // Filter Icon Button
        ],
      ),
    );
  }

  Widget _buildShimmerSummaryCards() {
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Container(
            height: 100, // Altura aprox de las tarjetas
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == 3 ? 0 : 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlaceholder(height: 14, width: 100), // Título tarjeta
                    const SizedBox(height: 8),
                    _buildPlaceholder(height: 20, width: 50), // Número grande
                  ],
                ),
                _buildPlaceholder(
                  height: 40,
                  width: 40,
                  shape: BoxShape.circle,
                ), // Icono circular
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerTableContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // Simula el borde si lo tiene el contenedor real
        // border: Border.all(color: Colors.grey.shade200)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlaceholder(
                  height: 18,
                  width: 180,
                ), // "Listado de Solicitudes"
                const SizedBox(height: 16),
                // --- Shimmer para Tabs y Botones de acción ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tabs
                    Row(
                      children: List.generate(
                        4,
                        (i) => Padding(
                          padding: EdgeInsets.only(right: i == 3 ? 0 : 16.0),
                          child: _buildPlaceholder(
                            height: 30,
                            width: 80,
                            radius: 15,
                          ),
                        ),
                      ),
                    ),
                    // Action Buttons
                    Row(
                      children: [
                        _buildPlaceholder(
                          height: 36,
                          width: 130,
                          radius: 6,
                        ), // Filtrar fecha
                        const SizedBox(width: 8),
                        _buildPlaceholder(
                          height: 36,
                          width: 110,
                          radius: 6,
                        ), // Descargar
                        const SizedBox(width: 8),
                        _buildPlaceholder(
                          height: 36,
                          width: 70,
                          radius: 6,
                        ), // Toggle view
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ), // O usa un placeholder si prefieres
          // --- Shimmer para la Tabla ---
          _buildShimmerDataTable(),
        ],
      ),
    );
  }

  Widget _buildShimmerDataTable() {
    // Simula unas cuantas filas de la tabla
    int numberOfShimmerRows = 6;
    int numberOfColumns = 8; // Ajusta al número de columnas de tu tabla

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ), // Padding para la tabla
      child: Column(
        children: [
          // --- Shimmer para la Fila de Cabecera ---
          Container(
            height: 40, // Altura de la cabecera
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05)), // Fondo cabecera (opcional)
            child: Row(
              children: List.generate(
                numberOfColumns,
                (index) => Expanded(
                  // Ajusta los flex si tienes anchos muy diferentes en columnas
                  flex:
                      (index == 2 || index == 4)
                          ? 2
                          : 1, // Ejemplo: Empleado y Empresa más anchos
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildPlaceholder(
                      height: 14,
                      width: double.infinity,
                    ), // Ancho máximo dentro de Expanded
                  ),
                ),
              ),
            ),
          ),
          // Divider debajo de cabecera
          // Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          // --- Shimmer para las Filas de Datos ---
          ...List.generate(
            numberOfShimmerRows,
            (rowIndex) => Container(
              height: 68, // Altura aprox de las filas de datos
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              // decoration: BoxDecoration(
              //   border: Border(bottom: BorderSide(color: Colors.grey.shade200)) // Bordes entre filas
              // ),
              child: Row(
                children: List.generate(
                  numberOfColumns,
                  (colIndex) => Expanded(
                    flex: (colIndex == 2 || colIndex == 4) ? 2 : 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildCellPlaceholder(
                        rowIndex,
                        colIndex,
                      ), // Llama a helper para variedad
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para variar un poco el contenido de las celdas shimmer
  Widget _buildCellPlaceholder(int rowIndex, int colIndex) {
    double widthFactor = 0.8; // Por defecto ocupa el 80% del ancho
    double height = 14;
    bool isMultiLine = false;

    // Simula contenido diferente por columna (ajusta según tu tabla real)
    switch (colIndex) {
      case 0:
        widthFactor = 0.6;
        break; // Código (corto)
      case 1: // Tipo (icono + 2 líneas)
        return Row(
          children: [
            _buildPlaceholder(height: 36, width: 36, shape: BoxShape.circle),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlaceholder(height: height, width: 70),
                const SizedBox(height: 4),
                _buildPlaceholder(height: height, width: 50),
              ],
            ),
          ],
        );
      case 2:
        isMultiLine = true;
        break; // Empleado (3 líneas)
      case 3:
        widthFactor = 0.9;
        break; // Periodo
      case 4:
        isMultiLine = true;
        widthFactor = 0.8;
        break; // Empresa (2 líneas)
      case 5:
        widthFactor = 0.7;
        break; // Solicitado
      case 6:
        return _buildPlaceholder(
          height: 24,
          width: 70,
          radius: 12,
        ); // Estado (Badge)
      case 7: // Acciones (2 botones)
        return Row(
          children: [
            _buildPlaceholder(height: 30, width: 80, radius: 4),
            const SizedBox(width: 8),
            _buildPlaceholder(height: 30, width: 30, radius: 4),
          ],
        );
    }

    if (isMultiLine) {
      // Simula 2 o 3 líneas de texto
      int lines = (colIndex == 2) ? 3 : 2;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          lines,
          (i) => Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 4.0),
            child: _buildPlaceholder(
              height: height,
              width: double.infinity * (widthFactor - (i * 0.1)),
            ), // Líneas más cortas abajo
          ),
        ),
      );
    } else {
      // Una sola línea
      return Align(
        // Alinea a la izquierda por defecto
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: _buildPlaceholder(height: height, width: double.infinity),
        ),
      );
    }
  }
}
