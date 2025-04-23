import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
// Asegúrate que la ruta a tus recursos sea correcta
import 'package:technical_test/presentation/resources/resources.dart';
// Importa Lucide Icons

// --- Constantes específicas del Sidebar ---
const double _sidebarWidth = 270.0;
const double _logoHeight = 60.0;
const double _userInfoHeight = 80.0;
const double _indicatorWidth = 4.0; // Ancho del indicador izquierdo
const double _childIndent = 20.0; // Indentación base para hijos

// Define el color de selección directamente (o mantenlo en AppColors)
const Color _selectedItemColor = Colors.white;
const double _selectedItemBackgroundOpacity =
    0.10; // Opacidad del fondo del item seleccionado
const double _connectorLineOpacity =
    0.4; // Opacidad de la línea conectora de hijos

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Reemplaza este valor con el estado real de tu aplicación
    final String currentRoute =
        'Solicitudes'; // Ejemplo: La ruta/item actualmente seleccionado

    return Container(
      width: _sidebarWidth,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          // 1. Header del Sidebar (Logo)
          const _SidebarHeader(),

          // 2. Información del Usuario
          const _UserInfo(),

          // 3. Lista de Navegación (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- Grupo Portal del Empleado ---
                  _SidebarExpansionItem(
                    title: 'Portal del Empleado',
                    icon: LucideIcons.folder,
                    initiallyExpanded: true, // Empieza expandido por defecto
                    // Evalúa si algún hijo está seleccionado para mantener el grupo expandido
                    forceExpanded: [
                      'Solicitudes',
                      'Comprobantes de Pago',
                      'Informe de Cursos',
                      'Cola de Aprobación',
                    ].contains(currentRoute),
                    children: [
                      _SidebarItem(
                        title: 'Solicitudes',
                        icon: LucideIcons.fileText,
                        isSelected: currentRoute == 'Solicitudes',
                        isChild: true, // Indicar que es un hijo
                        onTap: () {
                          /* TODO: Navegar a Solicitudes */
                        },
                      ),
                      _SidebarItem(
                        title: 'Comprobantes de Pago',
                        icon: LucideIcons.receipt,
                        isSelected: currentRoute == 'Comprobantes de Pago',
                        isChild: true,
                        onTap: () {
                          /* TODO: Navegar a Comprobantes */
                        },
                      ),
                      _SidebarItem(
                        title: 'Informe de Cursos',
                        icon: LucideIcons.graduationCap,
                        isSelected: currentRoute == 'Informe de Cursos',
                        isChild: true,
                        onTap: () {
                          /* TODO: Navegar a Cursos */
                        },
                      ),
                      // _SidebarItem(
                      //   title: 'Cola de Aprobación',
                      //   icon: LucideIcons.clipboardCheck,
                      //   isSelected: currentRoute == 'Cola de Aprobación',
                      //   isChild: true,
                      //   onTap: () {
                      //     /* TODO: Navegar a Aprobación */
                      //   },
                      // ),
                    ],
                  ),
                  // --- Grupo Reclutamiento ---
                  _SidebarExpansionItem(
                    title: 'Reclutamiento',
                    icon: LucideIcons.users, // Cambiado icono
                    initiallyExpanded: false, // Por defecto no expandido
                    forceExpanded: [
                      /* Añadir rutas hijas si existen */
                    ].contains(currentRoute),
                    children: const [
                      // Añadir _SidebarItem hijos aquí si los hubiera
                      _SidebarItem(
                        title: 'Subitem Reclutamiento 1',
                        icon: LucideIcons.userCheck,
                        isChild: true,
                      ),
                      _SidebarItem(
                        title: 'Subitem Reclutamiento 2',
                        icon: LucideIcons.userCog,
                        isChild: true,
                      ),
                    ],
                  ),
                  // --- Grupo Portal del Candidato ---
                  _SidebarExpansionItem(
                    title: 'Portal del Candidato',
                    icon: LucideIcons.contact, // Cambiado icono
                    initiallyExpanded: false,
                    forceExpanded: [
                      /* Añadir rutas hijas si existen */
                    ].contains(currentRoute),
                    children: const [
                      // Añadir _SidebarItem hijos aquí si los hubiera
                      _SidebarItem(
                        title: 'Subitem Candidato',
                        icon: LucideIcons.userSearch,
                        isChild: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Separador
          const Divider(color: AppColors.dividerColor, height: 1, thickness: 1),

          // 5. Opciones Inferiores
          _SidebarItem(
            title: 'Ayuda y Soporte',
            icon: LucideIcons.circleHelp,
            isSelected: currentRoute == 'Ayuda',
            onTap: () {
              /* TODO: Navegar a Ayuda */
            },
          ),
          _SidebarItem(
            title: 'Configuración',
            icon: LucideIcons.settings,
            isSelected: currentRoute == 'Configuracion',
            onTap: () {
              /* TODO: Navegar a Configuración */
            },
          ),
          _SidebarItem(
            title: 'Cerrar Sesión',
            icon: LucideIcons.logOut,
            onTap: () {
              /* TODO: Implementar cierre de sesión */
            },
          ),
          const SizedBox(height: 10), // Pequeño espacio al final
        ],
      ),
    );
  }
}

// --- Widgets Internos del Sidebar ---

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _logoHeight,
      color: AppColors.sidebarHeaderBackground,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // Logo 'HT' en contenedor blanco
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                6,
              ), // Esquinas ligeramente redondeadas
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ), // Ajusta el padding interno
            child: const Text(
              'HT',
              style: TextStyle(
                color: AppColors.primaryPurple, // Color del texto del logo
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12), // Espacio entre logo y texto
          const Text(
            'Ho-Tech',
            style: TextStyle(
              color: AppColors.sidebarText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(), // Empuja el icono de chevron a la derecha
          Icon(
            LucideIcons
                .chevronLeft, // Icono para colapsar/expandir sidebar (opcional)
            color: AppColors.sidebarIcon.withOpacity(0.7),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    // Añadimos un InkWell para posible acción futura (ir al perfil?)
    return InkWell(
      onTap: () {
        /* Acción al tocar info de usuario */
      },
      child: Container(
        height: _userInfoHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepPurpleAccent, // Color para el avatar
              child: Text(
                'JP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Juan Pérez',
                    style: TextStyle(
                      color: AppColors.sidebarText,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Administrador',
                    style: TextStyle(
                      color: AppColors.sidebarText.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isChild; // Nuevo: para saber si es hijo y aplicar indentación
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.isChild = false, // Por defecto no es hijo
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Container(
        // Margen vertical para separar items
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color.fromARGB(
                    46,
                    255,
                    255,
                    255,
                  ).withOpacity(_selectedItemBackgroundOpacity)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
          child: InkWell(
            onTap:
                onTap ??
                () {
                  print('Tapped on $title');
                },
            borderRadius: BorderRadius.circular(6.0),
            splashColor: _selectedItemColor.withOpacity(0.1),
            highlightColor: _selectedItemColor.withOpacity(0.05),
            child: Padding(
              // Padding interno del item
              padding: EdgeInsets.only(
                left: 20,
                right: 10.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Contenido Principal (Icono y Texto)
                  Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.subtitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  // Indicador izquierdo si está seleccionado
                  if (isSelected)
                    Positioned(
                      left: -20,
                      top: -10,
                      bottom: -10,
                      child: Container(
                        width: 5,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarExpansionItem extends StatefulWidget {
  const _SidebarExpansionItem({
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
    this.forceExpanded,
  });

  final String title;
  final IconData icon;
  final List<_SidebarItem> children;
  final bool initiallyExpanded;
  final bool? forceExpanded;

  @override
  State<_SidebarExpansionItem> createState() => _SidebarExpansionItemState();
}

class _SidebarExpansionItemState extends State<_SidebarExpansionItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.forceExpanded ?? widget.initiallyExpanded;
  }

  // Actualiza el estado si forceExpanded cambia (por ejemplo, al navegar)
  @override
  void didUpdateWidget(covariant _SidebarExpansionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.forceExpanded != null && widget.forceExpanded != _isExpanded) {
      setState(() {
        _isExpanded = widget.forceExpanded!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Sobrescribimos el color del divisor que ExpansionTile añade por defecto
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // key: PageStorageKey(widget.title), // Ayuda a mantener estado de expansión en listas largas/scroll
        initiallyExpanded: _isExpanded,
        onExpansionChanged:
            (bool expanding) => setState(() => _isExpanded = expanding),
        maintainState: true, // Mantiene los hijos en el árbol incluso colapsado
        leading: Icon(widget.icon, color: Colors.white, size: 20),
        title: Text(
          widget.title,
          style: AppTextStyles.subtitle,
          overflow: TextOverflow.ellipsis,
        ),
        // Icono de expansión personalizado
        trailing: Icon(
          _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
          size: 18,
          color: AppColors.sidebarIcon.withOpacity(0.7),
        ),
        // Controlamos el color del ícono de expansión (aunque usamos trailing)
        iconColor: AppColors.sidebarIcon.withOpacity(0.7),
        collapsedIconColor: AppColors.sidebarIcon.withOpacity(0.7),
        // Añadimos padding al Título, removemos el padding por defecto
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ), // Ajusta padding vertical
        //
        // QUITAMOS el childrenPadding aquí, lo manejaremos nosotros
        childrenPadding: EdgeInsets.zero,
        // Usamos clipBehavior para evitar que la línea se corte si el ExpansionTile recorta
        clipBehavior: Clip.antiAlias,
        // Quitar formas/bordes por defecto
        collapsedShape: const Border(),
        shape: const Border(),
        // Dibujamos los hijos envueltos para añadir la línea conectora
        children: [_ExpansionTileChildrenWrapper(children: widget.children)],
      ),
    );
  }
}

// Widget interno para dibujar la línea vertical conectora para los hijos
class _ExpansionTileChildrenWrapper extends StatelessWidget {
  final List<Widget> children;

  const _ExpansionTileChildrenWrapper({required this.children});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;
    final double lineLeftOffset =
        _childIndent + 6 + (iconSize / 2) - (_indicatorWidth / 2);

    return Stack(
      children: [
        Positioned(
          left: lineLeftOffset,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1.5,
            color: const Color.fromARGB(56, 255, 255, 255).withOpacity(0.15),
          ),
        ),
        // --- Los Hijos ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ],
    );
  }
}
