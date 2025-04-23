import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';
import 'constants.dart';
import './sidebar_header.dart';
import './user_info.dart';
import './sidebar_item.dart';
import './sidebar_expansion_item.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = 'Solicitudes';

    final List<String> portalEmpleadoRoutes = [
      'Solicitudes',
      'Comprobantes de Pago',
      'Informe de Cursos',
    ];
    final List<String> reclutamientoRoutes = [
      'Subitem Reclutamiento 1',
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
      width: sidebarWidth,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          const SidebarHeader(),
          const UserInfo(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SidebarExpansionItem(
                    title: 'Portal del Empleado',
                    icon: LucideIcons.folder,
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
                        onTap: () {
                          print('Navegar a Solicitudes');
                        },
                      ),
                      SidebarItem(
                        title: 'Comprobantes de Pago',
                        icon: LucideIcons.receipt,
                        isSelected: currentRoute == 'Comprobantes de Pago',
                        isChild: true,
                        onTap: () {
                          print('Navegar a Comprobantes');
                        },
                      ),
                      SidebarItem(
                        title: 'Informe de Cursos',
                        icon: LucideIcons.graduationCap,
                        isSelected: currentRoute == 'Informe de Cursos',
                        isChild: true,
                        onTap: () {
                          print('Navegar a Cursos');
                        },
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
                    children: const [
                      SidebarItem(
                        title: 'Subitem Reclutamiento 1',
                        icon: LucideIcons.userCheck,
                        isChild: true,
                      ),
                      SidebarItem(
                        title: 'Subitem Reclutamiento 2',
                        icon: LucideIcons.userCog,
                        isChild: true,
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
                    children: const [
                      SidebarItem(
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
          Divider(
            color:
                AppColors.dividerColor?.withOpacity(0.1) ??
                Colors.white.withOpacity(0.1),
            height: 1,
            thickness: 1,
          ),
          SidebarItem(
            title: 'Ayuda y Soporte',
            icon: LucideIcons.circleHelp,
            isSelected: currentRoute == 'Ayuda',
            onTap: () {
              print('Navegar a Ayuda');
            },
          ),
          SidebarItem(
            title: 'Configuración',
            icon: LucideIcons.settings,
            isSelected: currentRoute == 'Configuracion',
            onTap: () {
              print('Navegar a Configuración');
            },
          ),
          SidebarItem(
            title: 'Cerrar Sesión',
            icon: LucideIcons.logOut,
            onTap: () {
              print('Cerrar Sesión');
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
