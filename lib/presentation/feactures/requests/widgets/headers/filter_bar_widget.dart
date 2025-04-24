import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/feactures/requests/blocs/blocs.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  // Lista de tipos de solicitud (mocked data)
  final List<String> _tiposSolicitud = [
    'Cambio Alojamiento',
    'Cambio de horario',
    'Cambio de posición',
    'Cambio de propina',
    'Cartas',
    'Licencias Médicas',
    'Permisos',
    'Vacaciones',
    'Uniformes',
  ];

  // Lista de estados (mocked data)
  final List<String> _estados = ['Pendiente', 'Aprobada', 'Rechazada'];

  // Estado para controlar los checkboxes seleccionados
  final Map<String, bool> _tiposSolicitudSeleccionados = {};
  final Map<String, bool> _estadosSeleccionados = {};

  // Controller para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(flex: 2, child: _buildSearchField(context)),
          const SizedBox(width: 16),

          // Dropdown Tipo Solicitud
          Expanded(
            flex: 1,
            child: CustomDropdownWidget(
              title: 'Todas las solicitudes',
              headerTitle: 'Tipos de solicitud',
              items: _tiposSolicitud,
              selectedItems: _tiposSolicitudSeleccionados,
              onSelectionChanged: (selectedMap) {
                setState(() {
                  _tiposSolicitudSeleccionados.clear();
                  _tiposSolicitudSeleccionados.addAll(selectedMap);
                });

                // Enviar el evento de tipos seleccionados al bloc
                context.read<RequestFilterBloc>().add(
                  TypeFilterChanged(
                    Map<String, bool>.from(_tiposSolicitudSeleccionados),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Dropdown Estado
          Expanded(
            flex: 1,
            child: CustomDropdownWidget(
              title: 'Todos los estados',
              headerTitle: 'Estado de solicitud',
              items: _estados,
              selectedItems: _estadosSeleccionados,
              onSelectionChanged: (selectedMap) {
                setState(() {
                  _estadosSeleccionados.clear();
                  _estadosSeleccionados.addAll(selectedMap);
                });

                // Enviar el evento de estados seleccionados al bloc
                context.read<RequestFilterBloc>().add(
                  StatusFilterChanged(
                    Map<String, bool>.from(_estadosSeleccionados),
                  ),
                );
              },
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
                // Limpiar el campo de búsqueda
                _searchController.clear();
                // Enviar el evento para limpiar los filtros al bloc
                context.read<RequestFilterBloc>().add(FiltersCleared());
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar solicitudes...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 18,
              color: Colors.grey.shade600,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: (value) {
            // Enviar el evento al bloc cuando cambia el texto
            context.read<RequestFilterBloc>().add(SearchTermChanged(value));
          },
        ),
      ),
    );
  }
}
