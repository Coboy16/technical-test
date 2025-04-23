import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
// Asegúrate que la ruta a tus recursos sea correcta
import 'package:technical_test/presentation/resources/resources.dart'; // Asumiendo que AppColors y AppTextStyles están aquí

// --- Constantes específicas del Sidebar ---
const double _sidebarWidth = 270.0;
const double _logoHeight = 60.0;
const double _userInfoHeight = 80.0;
const double _indicatorWidth =
    4.0; // Ancho del indicador izquierdo (Usado implícitamente en el Positioned)
const double _childIndent = 20.0; // Indentación base para hijos
const double _parentHorizontalPadding =
    20.0; // Padding horizontal para items padres
const double _itemHorizontalPadding =
    20.0; // Padding horizontal para items hijos (dentro del InkWell)
const double _itemVerticalPadding = 10.0; // Padding vertical para items
const double _itemVerticalMargin = 2.0; // Margen vertical entre items
const double _itemHorizontalMargin = 8.0; // Margen horizontal para items
const double _borderRadius = 6.0; // Radio de borde para items

// Define el color de selección directamente (o mantenlo en AppColors)
const Color _selectedItemColor = Colors.white;
const double _selectedItemBackgroundOpacity =
    0.10; // Opacidad del fondo del item seleccionado
// const double _connectorLineOpacity = 0.4; // Opacidad de la línea conectora de hijos (Usada en _ExpansionTileChildrenWrapper)

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Reemplaza este valor con el estado real de tu aplicación
    final String currentRoute =
        'Solicitudes'; // Ejemplo: La ruta/item actualmente seleccionado

    // --- Calcula qué grupo padre está activo ---
    final List<String> portalEmpleadoRoutes = [
      'Solicitudes',
      'Comprobantes de Pago',
      'Informe de Cursos',
      'Cola de Aprobación', // Añadir si se descomenta el item
    ];
    final List<String> reclutamientoRoutes = [
      'Subitem Reclutamiento 1', // Asegúrate que coincidan con los títulos o identificadores reales
      'Subitem Reclutamiento 2',
    ];
    final List<String> portalCandidatoRoutes = ['Subitem Candidato'];

    final bool isPortalEmpleadoSelected = portalEmpleadoRoutes.contains(
      currentRoute,
    );
    final bool isReclutamientoSelected = reclutamientoRoutes.contains(
      currentRoute,
    );
    final bool isPortalCandidatoSelected = portalCandidatoRoutes.contains(
      currentRoute,
    );

    return Container(
      width: _sidebarWidth,
      color:
          AppColors
              .sidebarBackground, // Asegúrate que AppColors.sidebarBackground esté definido
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
                    forceExpanded:
                        isPortalEmpleadoSelected, // Usa el flag calculado
                    isParentSelected:
                        isPortalEmpleadoSelected, // NUEVO: Indica si el padre debe resaltarse
                    childrenRoutes:
                        portalEmpleadoRoutes, // Pasa las rutas hijas para la lógica interna si fuera necesario
                    children: [
                      _SidebarItem(
                        title: 'Solicitudes',
                        icon: LucideIcons.fileText,
                        isSelected: currentRoute == 'Solicitudes',
                        isChild: true, // Indicar que es un hijo
                        onTap: () {
                          /* TODO: Navegar a Solicitudes */
                          print('Navegar a Solicitudes');
                        },
                      ),
                      _SidebarItem(
                        title: 'Comprobantes de Pago',
                        icon: LucideIcons.receipt,
                        isSelected: currentRoute == 'Comprobantes de Pago',
                        isChild: true,
                        onTap: () {
                          /* TODO: Navegar a Comprobantes */
                          print('Navegar a Comprobantes');
                        },
                      ),
                      _SidebarItem(
                        title: 'Informe de Cursos',
                        icon: LucideIcons.graduationCap,
                        isSelected: currentRoute == 'Informe de Cursos',
                        isChild: true,
                        onTap: () {
                          /* TODO: Navegar a Cursos */
                          print('Navegar a Cursos');
                        },
                      ),
                      // _SidebarItem(
                      //   title: 'Cola de Aprobación',
                      //   icon: LucideIcons.clipboardCheck,
                      //   isSelected: currentRoute == 'Cola de Aprobación',
                      //   isChild: true,
                      //   onTap: () {
                      //     /* TODO: Navegar a Aprobación */
                      //      print('Navegar a Aprobación');
                      //   },
                      // ),
                    ],
                  ),
                  // --- Grupo Reclutamiento ---
                  _SidebarExpansionItem(
                    title: 'Reclutamiento',
                    icon: LucideIcons.users,
                    initiallyExpanded: false,
                    forceExpanded: isReclutamientoSelected,
                    isParentSelected: isReclutamientoSelected, // NUEVO
                    childrenRoutes: reclutamientoRoutes,
                    children: const [
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
                    icon: LucideIcons.contact,
                    initiallyExpanded: false,
                    forceExpanded: isPortalCandidatoSelected,
                    isParentSelected: isPortalCandidatoSelected, // NUEVO
                    childrenRoutes: portalCandidatoRoutes,
                    children: const [
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
          Divider(
            color:
                AppColors.dividerColor?.withOpacity(0.1) ??
                Colors.white.withOpacity(0.1),
            height: 1,
            thickness: 1,
          ), // Asegúrate que AppColors.dividerColor esté definido
          // 5. Opciones Inferiores
          // Estos son items normales, no hijos, así que isChild es false (por defecto)
          _SidebarItem(
            title: 'Ayuda y Soporte',
            icon: LucideIcons.circleHelp,
            isSelected: currentRoute == 'Ayuda',
            onTap: () {
              /* TODO: Navegar a Ayuda */
              print('Navegar a Ayuda');
            },
          ),
          _SidebarItem(
            title: 'Configuración',
            icon: LucideIcons.settings,
            isSelected: currentRoute == 'Configuracion',
            onTap: () {
              /* TODO: Navegar a Configuración */
              print('Navegar a Configuración');
            },
          ),
          _SidebarItem(
            title: 'Cerrar Sesión',
            icon: LucideIcons.logOut,
            onTap: () {
              /* TODO: Implementar cierre de sesión */
              print('Cerrar Sesión');
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
    // Usar colores definidos o fallback
    final Color headerBg =
        AppColors.sidebarHeaderBackground ?? AppColors.primaryPurple;
    final Color logoText =
        AppColors.primaryPurple ?? Theme.of(context).primaryColor;
    final Color headerText = AppColors.sidebarText ?? Colors.white;
    final Color iconColor = (AppColors.sidebarIcon ?? Colors.white).withOpacity(
      0.7,
    );

    return Container(
      height: _logoHeight,
      color: headerBg,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: _parentHorizontalPadding),
      child: Row(
        children: [
          // Logo 'HT' en contenedor blanco
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'HT',
              style: TextStyle(
                color: logoText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12), // Espacio entre logo y texto
          Text(
            'Ho-Tech',
            style: TextStyle(
              color: headerText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(), // Empuja el icono de chevron a la derecha
          Icon(LucideIcons.chevronLeft, color: iconColor, size: 20),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    // Usar colores definidos o fallback
    final Color textColor = AppColors.sidebarText ?? Colors.white;
    final Color subTextColor = textColor.withOpacity(0.7);

    return InkWell(
      onTap: () {
        /* Acción al tocar info de usuario */
        print('Info Usuario Tapped');
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
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Administrador',
                    style: TextStyle(color: subTextColor, fontSize: 12),
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

// _SidebarItem no necesita cambios significativos para este requerimiento
class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool
  isChild; // Para saber si aplicar indentación extra y estilo de hijo
  final VoidCallback? onTap;

  const _SidebarItem({
    super.key, // Añadido Key
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.isChild = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color iconColor = Colors.white;
    final TextStyle textStyle =
        AppTextStyles.subtitle ??
        TextStyle(
          color: textColor,
          fontSize: 14,
        ); // Usar AppTextStyles o fallback

    // Calcula el padding izquierdo basado en si es hijo o no
    final double leftPadding =
        isChild
            ? (_parentHorizontalPadding + _itemHorizontalPadding)
            : _parentHorizontalPadding;
    final double indicatorLeftPos =
        -leftPadding; // Ajusta la posición del indicador

    return Padding(
      // Aplicar padding izquierdo para la indentación si es hijo
      padding: EdgeInsets.only(left: isChild ? _childIndent : 0),
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Container(
          // Margen vertical y horizontal para separar items
          margin: const EdgeInsets.symmetric(
            vertical: _itemVerticalMargin,
            horizontal: _itemHorizontalMargin,
          ),
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
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(_borderRadius),
            child: InkWell(
              onTap: onTap ?? () => print('Tapped on $title'),
              borderRadius: BorderRadius.circular(_borderRadius),
              splashColor: _selectedItemColor.withOpacity(0.1),
              highlightColor: _selectedItemColor.withOpacity(0.05),
              child: Padding(
                // Padding interno del item
                padding: EdgeInsets.only(
                  left: _itemHorizontalPadding, // Padding interno consistente
                  right:
                      _itemHorizontalPadding /
                      2, // Menos padding derecho para el icono trailing si hubiera
                  top: _itemVerticalPadding,
                  bottom: _itemVerticalPadding,
                ),
                child: Stack(
                  clipBehavior:
                      Clip.none, // Permite que el indicador se dibuje fuera
                  children: [
                    // Contenido Principal (Icono y Texto)
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
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
                        left: -19,
                        top: -_itemVerticalPadding,
                        bottom: -_itemVerticalPadding,
                        child: Container(
                          width: _indicatorWidth,
                          decoration: const BoxDecoration(
                            color: _selectedItemColor, // Color del indicador
                            borderRadius: BorderRadius.only(
                              // Radio solo en el lado visible
                              topLeft: Radius.circular(_borderRadius),
                              bottomLeft: Radius.circular(_borderRadius),
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
      ),
    );
  }
}

// --- _SidebarExpansionItem MODIFICADO ---
class _SidebarExpansionItem extends StatefulWidget {
  const _SidebarExpansionItem({
    super.key, // Añadido Key
    required this.title,
    required this.icon,
    required this.children,
    required this.childrenRoutes, // Rutas hijas para lógica interna
    required this.isParentSelected, // NUEVO: Para controlar el resaltado del padre
    this.initiallyExpanded = false,
    this.forceExpanded,
  });

  final String title;
  final IconData icon;
  final List<_SidebarItem> children;
  final List<String> childrenRoutes;
  final bool isParentSelected; // Indica si el *padre* debe resaltar
  final bool initiallyExpanded;
  final bool? forceExpanded; // Para mantener expandido si un hijo está activo

  @override
  State<_SidebarExpansionItem> createState() => _SidebarExpansionItemState();
}

class _SidebarExpansionItemState extends State<_SidebarExpansionItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    // Prioriza forceExpanded, luego initiallyExpanded
    _isExpanded = widget.forceExpanded ?? widget.initiallyExpanded;
  }

  // Actualiza el estado si forceExpanded cambia (por ejemplo, al navegar)
  @override
  void didUpdateWidget(covariant _SidebarExpansionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si forceExpanded tiene un valor y es diferente al estado actual, actualiza la expansión
    if (widget.forceExpanded != null && widget.forceExpanded != _isExpanded) {
      setState(() {
        _isExpanded = widget.forceExpanded!;
      });
    }
    // Si el estado de selección del padre cambia (aunque no afecte la expansión directamente aquí)
    if (widget.isParentSelected != oldWidget.isParentSelected) {
      setState(() {}); // Reconstruye para aplicar el estilo visual
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color iconColor = Colors.white;
    final TextStyle textStyle =
        AppTextStyles.subtitle ??
        TextStyle(
          color: textColor,
          fontSize: 14,
        ); // Usar AppTextStyles o fallback
    final Color chevronColor = iconColor.withOpacity(0.7);

    // Calcula la posición del indicador para el padre
    // El padding izquierdo del contenido del padre es _parentHorizontalPadding
    final double indicatorLeftPos = -_parentHorizontalPadding;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Personalizado (similar a _SidebarItem) ---
        Container(
          // Margen similar a _SidebarItem para consistencia
          margin: const EdgeInsets.symmetric(
            vertical: _itemVerticalMargin,
            horizontal: _itemHorizontalMargin,
          ),
          decoration: BoxDecoration(
            color:
                widget
                        .isParentSelected // Usa el flag isParentSelected
                    ? _selectedItemColor.withOpacity(
                      _selectedItemBackgroundOpacity,
                    )
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(_borderRadius),
            child: InkWell(
              onTap: _toggleExpansion, // Expande/colapsa al tocar
              borderRadius: BorderRadius.circular(_borderRadius),
              splashColor: _selectedItemColor.withOpacity(0.1),
              highlightColor: _selectedItemColor.withOpacity(0.05),
              child: Padding(
                // Padding interno del header del item expandible
                padding: const EdgeInsets.only(
                  left:
                      _parentHorizontalPadding, // Padding izquierdo para el contenido
                  right:
                      _parentHorizontalPadding, // Padding derecho para el chevron
                  top: _itemVerticalPadding,
                  bottom: _itemVerticalPadding,
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Permite dibujar indicador fuera
                  children: [
                    // Contenido Principal (Icono, Texto, Chevron)
                    Row(
                      children: [
                        Icon(widget.icon, color: iconColor, size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: textStyle.copyWith(color: textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8), // Espacio antes del chevron
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 18,
                          color: chevronColor,
                        ),
                      ],
                    ),

                    // Indicador izquierdo si el padre está seleccionado
                    if (widget.isParentSelected)
                      Positioned(
                        left:
                            indicatorLeftPos, // Usa la posición calculada para padres
                        top: -_itemVerticalPadding, // Cubre padding vertical
                        bottom: -_itemVerticalPadding,
                        child: Container(
                          width: _indicatorWidth,
                          decoration: const BoxDecoration(
                            color: _selectedItemColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_borderRadius),
                              bottomLeft: Radius.circular(_borderRadius),
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

        // --- Hijos (Condicionalmente Visibles) ---
        // Usamos AnimatedCrossFade para una transición suave (opcional pero agradable)
        AnimatedCrossFade(
          firstChild: Container(), // Widget vacío cuando está colapsado
          secondChild: _ExpansionTileChildrenWrapper(
            children: widget.children,
          ), // Los hijos reales
          crossFadeState:
              _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: const Duration(
            milliseconds: 200,
          ), // Duración de la animación
          sizeCurve: Curves.easeInOut,
        ),

        // Alternativa sin animación:
        // if (_isExpanded)
        //   _ExpansionTileChildrenWrapper(children: widget.children),
      ],
    );
  }
}

// Widget interno para dibujar la línea vertical conectora para los hijos
// (Sin cambios necesarios aquí, pero asegurando que los offsets sean correctos)
class _ExpansionTileChildrenWrapper extends StatelessWidget {
  final List<Widget> children;

  const _ExpansionTileChildrenWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // Asegurarse que estos valores sean consistentes con _SidebarItem y la indentación
    const double iconSize = 20.0; // Tamaño del icono del hijo (_SidebarItem)
    const double childItemInternalPaddingLeft =
        _itemHorizontalPadding; // Padding izquierdo *dentro* del InkWell del hijo
    const double childTotalIndent =
        _childIndent; // Indentación total aplicada al hijo (_SidebarItem)

    // La línea debe alinearse con el centro del icono del hijo.
    // El icono está desplazado por: childTotalIndent (padding exterior) + childItemInternalPaddingLeft (padding interior) + iconSize / 2
    final double lineLeftOffset =
        -4 +
        childItemInternalPaddingLeft +
        (iconSize / 2) -
        (1.5 / 2); // 1.5 es el ancho de la línea

    return Stack(
      children: [
        // --- Línea Conectora Vertical ---
        Positioned(
          left: lineLeftOffset,
          top: 0, // Empieza desde arriba
          bottom: 0, // Termina abajo
          child: Container(
            width: 1, // Grosor de la línea
            // Color y opacidad de la línea
            color: _selectedItemColor.withOpacity(
              0.15,
            ), // Usar _selectedItemColor con baja opacidad para coherencia
          ),
        ),
        // --- Los Hijos ---
        // El padding izquierdo para la indentación ya se aplica en _SidebarItem
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ],
    );
  }
}
