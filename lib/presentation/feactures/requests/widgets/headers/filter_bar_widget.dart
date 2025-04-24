import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  // Lista de tipos de solicitud (mocked data)
  final List<String> _tiposSolicitud = [
    'Avances',
    'Cambio Alojamiento',
    'Cambio de horario',
    'Cambio de posición',
    'Cambio de propina',
    'Cartas',
    'Licencias Médicas',
    'Permisos',
  ];

  // Lista de estados (mocked data)
  final List<String> _estados = ['Pendiente', 'Aprobada', 'Rechazada'];

  // Estado para controlar los checkboxes seleccionados
  final Map<String, bool> _tiposSolicitudSeleccionados = {};
  final Map<String, bool> _estadosSeleccionados = {};

  // Estado para controlar la visibilidad de los dropdowns
  bool _mostrarDropdownTipos = false;
  bool _mostrarDropdownEstados = false;

  // Referencias para posicionar los dropdowns
  final GlobalKey _tiposKey = GlobalKey();
  final GlobalKey _estadosKey = GlobalKey();

  // Variables para almacenar las posiciones y tamaños
  OverlayEntry? _overlayEntryTipos;
  OverlayEntry? _overlayEntryEstados;

  @override
  void initState() {
    super.initState();
    // Inicializar todos como no seleccionados
    for (var tipo in _tiposSolicitud) {
      _tiposSolicitudSeleccionados[tipo] = false;
    }
    for (var estado in _estados) {
      _estadosSeleccionados[estado] = false;
    }
  }

  @override
  void dispose() {
    // Limpiar los overlays al desmontar el widget
    _removeOverlays();
    super.dispose();
  }

  // Método para mostrar/ocultar el dropdown de tipos
  void _toggleTiposDropdown() {
    if (_mostrarDropdownTipos) {
      _removeOverlays();
      setState(() {
        _mostrarDropdownTipos = false;
      });
    } else {
      _removeOverlays();
      _showTiposDropdown();
      setState(() {
        _mostrarDropdownTipos = true;
        _mostrarDropdownEstados = false;
      });
    }
  }

  // Método para mostrar/ocultar el dropdown de estados
  void _toggleEstadosDropdown() {
    if (_mostrarDropdownEstados) {
      _removeOverlays();
      setState(() {
        _mostrarDropdownEstados = false;
      });
    } else {
      _removeOverlays();
      _showEstadosDropdown();
      setState(() {
        _mostrarDropdownEstados = true;
        _mostrarDropdownTipos = false;
      });
    }
  }

  // Método para eliminar todos los overlays
  void _removeOverlays() {
    _overlayEntryTipos?.remove();
    _overlayEntryTipos = null;

    _overlayEntryEstados?.remove();
    _overlayEntryEstados = null;
  }

  // Método para mostrar el dropdown de tipos como overlay
  void _showTiposDropdown() {
    // Obtener la posición del botón de tipos
    final RenderBox? renderBox =
        _tiposKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    // Crear el overlay
    _overlayEntryTipos = OverlayEntry(
      builder:
          (context) => Positioned(
            top: position.dy + size.height,
            left: position.dx,
            width: size.width,
            child: CompositedTransformFollower(
              link: LayerLink(),
              showWhenUnlinked: true,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: GestureDetector(
                  onTap: () {}, // Prevent tap from closing the overlay
                  child: _buildTiposSolicitudDropdown(),
                ),
              ),
            ),
          ),
    );

    // Agregar el overlay a la superposición
    Overlay.of(context).insert(_overlayEntryTipos!);
  }

  // Método para mostrar el dropdown de estados como overlay
  void _showEstadosDropdown() {
    // Obtener la posición del botón de estados
    final RenderBox? renderBox =
        _estadosKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    // Crear el overlay
    _overlayEntryEstados = OverlayEntry(
      builder:
          (context) => Positioned(
            top: position.dy + size.height,
            left: position.dx,
            width: size.width,
            child: CompositedTransformFollower(
              link: LayerLink(),
              showWhenUnlinked: true,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: GestureDetector(
                  onTap: () {}, // Prevent tap from closing the overlay
                  child: _buildEstadosDropdown(),
                ),
              ),
            ),
          ),
    );

    // Agregar el overlay a la superposición
    Overlay.of(context).insert(_overlayEntryEstados!);
  }

  @override
  Widget build(BuildContext context) {
    // Agregar un detector de gestos global para cerrar los dropdowns al hacer clic fuera
    return GestureDetector(
      onTap: () {
        if (_mostrarDropdownTipos || _mostrarDropdownEstados) {
          _removeOverlays();
          setState(() {
            _mostrarDropdownTipos = false;
            _mostrarDropdownEstados = false;
          });
        }
      },
      // El widget principal
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Campo de Búsqueda
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar solicitudes...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        LucideIcons.search,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Dropdown Tipo Solicitud
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _toggleTiposDropdown,
                child: Container(
                  key: _tiposKey, // Clave para obtener la posición
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Todas las solicitudes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Icon(
                        _mostrarDropdownTipos
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Dropdown Estado
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _toggleEstadosDropdown,
                child: Container(
                  key: _estadosKey, // Clave para obtener la posición
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Todos los estados',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Icon(
                        _mostrarDropdownEstados
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Botón de Filtros Adicionales
            IconButton(
              icon: const Icon(LucideIcons.funnelX, size: 15),
              color: Colors.grey.shade400,
              tooltip: 'Borrar filtros',
              onPressed: () {
                // Implementar lógica para borrar filtros
                setState(() {
                  // Resetear todos los filtros
                  for (var tipo in _tiposSolicitud) {
                    _tiposSolicitudSeleccionados[tipo] = false;
                  }
                  for (var estado in _estados) {
                    _estadosSeleccionados[estado] = false;
                  }
                  // Cerrar los dropdowns si están abiertos
                  _removeOverlays();
                  _mostrarDropdownTipos = false;
                  _mostrarDropdownEstados = false;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  // Widget para el dropdown de tipos de solicitud
  Widget _buildTiposSolicitudDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tipos de solicitud',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Divider(height: 1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _tiposSolicitud.map((tipo) {
                      return CheckboxListTile(
                        title: Text(tipo, style: const TextStyle(fontSize: 14)),
                        value: _tiposSolicitudSeleccionados[tipo],
                        onChanged: (bool? value) {
                          setState(() {
                            _tiposSolicitudSeleccionados[tipo] = value!;
                          });
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el dropdown de estados
  Widget _buildEstadosDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Estado de solicitud',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Divider(height: 1),
          Column(
            mainAxisSize: MainAxisSize.min,
            children:
                _estados.map((estado) {
                  return CheckboxListTile(
                    title: Text(estado, style: const TextStyle(fontSize: 14)),
                    value: _estadosSeleccionados[estado],
                    onChanged: (bool? value) {
                      setState(() {
                        _estadosSeleccionados[estado] = value!;
                      });
                    },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
