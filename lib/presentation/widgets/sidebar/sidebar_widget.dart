import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';
import 'constants.dart';
import './sidebar_header.dart';
import './user_info.dart';
import './sidebar_item.dart';
import './sidebar_expansion_item.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  // Optimización: reducir duración de animación
  static const Duration _animationDuration = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value: isExpanded ? 0.0 : 1.0,
    );

    _widthAnimation = Tween<double>(
      begin: sidebarWidth,
      end: collapsedSidebarWidth,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSidebar() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cálculo previo de rutas para mejorar rendimiento
    const String currentRoute = 'Solicitudes'; // Example

    final List<String> portalEmpleadoRoutes = [
      'Solicitudes',
      'Comprobantes de Pago',
      'Informe de Cursos',
      'Cola de Aprobación',
    ];
    final List<String> reclutamientoRoutes = [
      'Ofertas de Trabajo',
      'Candidatos',
      'Portal Público',
      'Pruebas Psicométricas',
      'Ajustes',
    ];
    final List<String> portalCandidatoRoutes = [
      'Subitem Candidato',
      'Mis Postulaciones',
      'Mi Perfil',
    ];

    final bool isPortalEmpleadoSelected = portalEmpleadoRoutes.contains(
      currentRoute,
    );
    final bool isReclutamientoSelected = reclutamientoRoutes.contains(
      currentRoute,
    );
    final bool isPortalCandidatoSelected = portalCandidatoRoutes.contains(
      currentRoute,
    );

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        final double expandedOpacity = 1.0 - _animationController.value;
        final double collapsedOpacity = _animationController.value;

        return Container(
          width: _widthAnimation.value,
          color: AppColors.sidebarBackground,
          child: Column(
            children: [
              SidebarHeaderWithToggle(
                isExpanded: isExpanded,
                onToggle: toggleSidebar,
                widthAnimation: _widthAnimation,
              ),

              // UserInfo con ClipRect para prevenir overflow
              ClipRect(
                child: AnimatedOpacity(
                  duration: _animationDuration,
                  opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                  child:
                      isExpanded || _animationController.value < 0.5
                          ? const UserInfo()
                          : const SizedBox.shrink(),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(), // Optimización de scroll
                  child: ClipRect(
                    // Añadimos ClipRect para evitar overflow durante animación
                    child: Stack(
                      clipBehavior:
                          Clip.hardEdge, // Forzamos clip para prevenir overflow
                      children: [
                        // Contenido expandido
                        AnimatedOpacity(
                          duration: _animationDuration,
                          opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                          child: IgnorePointer(
                            ignoring: !isExpanded,
                            child: _buildExpandedSidebar(
                              currentRoute,
                              portalEmpleadoRoutes,
                              reclutamientoRoutes,
                              portalCandidatoRoutes,
                              isPortalEmpleadoSelected,
                              isReclutamientoSelected,
                              isPortalCandidatoSelected,
                            ),
                          ),
                        ),

                        // Contenido colapsado
                        AnimatedOpacity(
                          duration: _animationDuration,
                          opacity: (collapsedOpacity * 1.2).clamp(0.0, 1.0),
                          child: IgnorePointer(
                            ignoring: isExpanded,
                            child: _buildCollapsedSidebar(
                              currentRoute,
                              portalEmpleadoRoutes,
                              reclutamientoRoutes,
                              portalCandidatoRoutes,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(
                color: AppColors.dividerColor.withOpacity(0.1),
                height: 1,
                thickness: 1,
              ),

              // Área de botones inferiores
              ClipRect(
                // Añadimos ClipRect para prevenir overflow
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior:
                      Clip.hardEdge, // Forzamos clip para prevenir overflow
                  children: [
                    // Botones expandidos
                    AnimatedOpacity(
                      duration: _animationDuration,
                      opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                      child: IgnorePointer(
                        ignoring: !isExpanded,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SidebarItem(
                              title: 'Ayuda y Soporte',
                              icon: LucideIcons.circleHelp,
                              isSelected: currentRoute == 'Ayuda',
                              onTap: () => print('Navegar a Ayuda'),
                            ),
                            SidebarItem(
                              title: 'Configuración',
                              icon: LucideIcons.settings,
                              isSelected: currentRoute == 'Configuracion',
                              onTap: () => print('Navegar a Configuración'),
                            ),
                            SidebarItem(
                              title: 'Cerrar Sesión',
                              icon: LucideIcons.logOut,
                              onTap: () => print('Cerrar Sesión'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botones colapsados
                    AnimatedOpacity(
                      duration: _animationDuration,
                      opacity: (collapsedOpacity * 1.2).clamp(0.0, 1.0),
                      child: IgnorePointer(
                        ignoring: isExpanded,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCollapsedItem(
                              LucideIcons.circleHelp,
                              currentRoute == 'Ayuda',
                              () => print('Navegar a Ayuda'),
                            ),
                            _buildCollapsedItem(
                              LucideIcons.settings,
                              currentRoute == 'Configuracion',
                              () => print('Navegar a Configuración'),
                            ),
                            _buildCollapsedItem(
                              LucideIcons.logOut,
                              false,
                              () => print('Cerrar Sesión'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandedSidebar(
    String currentRoute,
    List<String> portalEmpleadoRoutes,
    List<String> reclutamientoRoutes,
    List<String> portalCandidatoRoutes,
    bool isPortalEmpleadoSelected,
    bool isReclutamientoSelected,
    bool isPortalCandidatoSelected,
  ) {
    return Column(
      key: const ValueKey('expanded_content'),
      mainAxisSize: MainAxisSize.min, // Optimización para evitar layout issues
      children: [
        SidebarExpansionItem(
          title: 'Portal del Empleado',
          icon: LucideIcons.fileText,
          initiallyExpanded: true,
          forceExpanded: isPortalEmpleadoSelected,
          isParentSelected: isPortalEmpleadoSelected,
          childrenRoutes: portalEmpleadoRoutes,
          children: [
            SidebarItem(
              title: 'Solicitudes',
              icon: LucideIcons.fileText,
              isSelected: currentRoute == 'Solicitudes',
              isChild: true,
              onTap: () => print('Navegar a Solicitudes'),
            ),
            SidebarItem(
              title: 'Comprobantes de Pago',
              icon: LucideIcons.receipt,
              isSelected: currentRoute == 'Comprobantes de Pago',
              isChild: true,
              onTap: () => print('Navegar a Comprobantes'),
            ),
            SidebarItem(
              title: 'Informe de Cursos',
              icon: LucideIcons.graduationCap,
              isSelected: currentRoute == 'Informe de Cursos',
              isChild: true,
              onTap: () => print('Navegar a Cursos'),
            ),
            SidebarItem(
              title: 'Cola de Aprobación',
              icon: LucideIcons.fileCheck,
              isSelected: currentRoute == 'Cola de Aprobación',
              isChild: true,
              onTap: () => print('Navegar a Cola de Aprobación'),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Reclutamiento',
          icon: LucideIcons.users,
          initiallyExpanded: false,
          forceExpanded: isReclutamientoSelected,
          isParentSelected: isReclutamientoSelected,
          childrenRoutes: reclutamientoRoutes,
          children: [
            SidebarItem(
              title: 'Ofertas de Trabajo',
              icon: LucideIcons.briefcase,
              isSelected: currentRoute == 'Ofertas de Trabajo',
              isChild: true,
              onTap: () => print('Navegar a Ofertas de Trabajo'),
            ),
            SidebarItem(
              title: 'Candidatos',
              icon: LucideIcons.users,
              isSelected: currentRoute == 'Candidatos',
              isChild: true,
              onTap: () => print('Navegar a Candidatos'),
            ),
            SidebarItem(
              title: 'Portal Público',
              icon: LucideIcons.globe,
              isSelected: currentRoute == 'Portal Público',
              isChild: true,
              onTap: () => print('Navegar a Portal Público'),
            ),
            SidebarItem(
              title: 'Pruebas Psicométricas',
              icon: LucideIcons.brain,
              isSelected: currentRoute == 'Pruebas Psicométricas',
              isChild: true,
              onTap: () => print('Navegar a Pruebas Psicométricas'),
            ),
            SidebarItem(
              title: 'Ajustes',
              icon: LucideIcons.settings,
              isSelected: currentRoute == 'Ajustes',
              isChild: true,
              onTap: () => print('Navegar a Ajustes'),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Portal del Candidato',
          icon: LucideIcons.contact,
          initiallyExpanded: false,
          forceExpanded: isPortalCandidatoSelected,
          isParentSelected: isPortalCandidatoSelected,
          childrenRoutes: portalCandidatoRoutes,
          children: [
            SidebarItem(
              title: 'Subitem Candidato',
              icon: LucideIcons.userSearch,
              isChild: true,
              onTap: () {}, // Añadimos callback vacío para evitar null
            ),
            SidebarItem(
              title: 'Mis Postulaciones',
              icon: LucideIcons.clipboardList,
              isSelected: currentRoute == 'Mis Postulaciones',
              isChild: true,
              onTap: () => print('Navegar a Mis Postulaciones'),
            ),
            SidebarItem(
              title: 'Mi Perfil',
              icon: LucideIcons.circleUser,
              isSelected: currentRoute == 'Mi Perfil',
              isChild: true,
              onTap: () => print('Navegar a Mi Perfil'),
            ),
          ],
        ),
        SidebarItem(
          title: 'Evaluación de desempeño',
          icon: LucideIcons.chartLine,
          isSelected: currentRoute == 'Evaluación de desempeño',
          onTap: () => print('Navegar a Evaluación de desempeño'),
        ),
        SidebarItem(
          title: 'Consolidación',
          icon: LucideIcons.layers,
          isSelected: currentRoute == 'Consolidación',
          onTap: () => print('Navegar a Consolidación'),
        ),
        SidebarItem(
          title: 'Cálculos Impositivos',
          icon: LucideIcons.calculator,
          isSelected: currentRoute == 'Cálculos Impositivos',
          onTap: () => print('Navegar a Cálculos Impositivos'),
        ),
      ],
    );
  }

  Widget _buildCollapsedSidebar(
    String currentRoute,
    List<String> portalEmpleadoRoutes,
    List<String> reclutamientoRoutes,
    List<String> portalCandidatoRoutes,
  ) {
    return Column(
      key: const ValueKey('collapsed_content'),
      mainAxisSize: MainAxisSize.min, // Optimización para evitar layout issues
      children: [
        _buildCollapsedItem(
          LucideIcons.fileText,
          portalEmpleadoRoutes.contains(currentRoute),
          () => print('Navegar a Portal del Empleado'),
        ),
        _buildCollapsedItem(
          LucideIcons.users,
          reclutamientoRoutes.contains(currentRoute),
          () => print('Navegar a Reclutamiento'),
        ),
        _buildCollapsedItem(
          LucideIcons.contact,
          portalCandidatoRoutes.contains(currentRoute),
          () => print('Navegar a Portal del Candidato'),
        ),
        _buildCollapsedItem(
          LucideIcons.chartLine,
          currentRoute == 'Evaluación de desempeño',
          () => print('Navegar a Evaluación'),
        ),
        _buildCollapsedItem(
          LucideIcons.layers,
          currentRoute == 'Consolidación',
          () => print('Navegar a Consolidación'),
        ),
        _buildCollapsedItem(
          LucideIcons.calculator,
          currentRoute == 'Cálculos Impositivos',
          () => print('Navegar a Cálculos'),
        ),
      ],
    );
  }

  Widget _buildCollapsedItem(
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    // Mejoramos el rendimiento evitando cálculos dinámicos de ancho
    return ClipRect(
      child: Tooltip(
        message: _getTooltipMessage(icon),
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isSelected ? AppColors.primaryPurple : Colors.transparent,
                width: 1,
              ),
            ),
            height: 48,
            // Usamos ancho fijo para evitar cálculos costosos durante la animación
            width: collapsedSidebarWidth - 16,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Center(child: Icon(icon, color: Colors.white, size: 24)),
          ),
        ),
      ),
    );
  }

  // Helper para tooltips basados en icono
  String _getTooltipMessage(IconData icon) {
    if (icon == LucideIcons.fileText) return 'Portal del Empleado';
    if (icon == LucideIcons.users) return 'Reclutamiento';
    if (icon == LucideIcons.contact) return 'Portal del Candidato';
    if (icon == LucideIcons.chartLine) return 'Evaluación de desempeño';
    if (icon == LucideIcons.layers) return 'Consolidación';
    if (icon == LucideIcons.calculator) return 'Cálculos Impositivos';
    if (icon == LucideIcons.circleHelp) return 'Ayuda y Soporte';
    if (icon == LucideIcons.settings) return 'Configuración';
    if (icon == LucideIcons.logOut) return 'Cerrar Sesión';
    return '';
  }

  // Variables de rutas mantenidas para compatibilidad
  final List<String> portalEmpleadoRoutes = const [
    'Solicitudes',
    'Comprobantes de Pago',
    'Informe de Cursos',
    'Cola de Aprobación',
  ];
  final List<String> reclutamientoRoutes = const [
    'Ofertas de Trabajo',
    'Candidatos',
    'Portal Público',
    'Pruebas Psicométricas',
    'Ajustes',
  ];
  final List<String> portalCandidatoRoutes = const [
    'Subitem Candidato',
    'Mis Postulaciones',
    'Mi Perfil',
  ];
}
