import 'package:flutter/material.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/widgets.dart';

class RequestActionHandler {
  // Método para mostrar flujo de aprobación
  static void showApprovalFlow({
    required BuildContext context,
    required RequestData request,
    required Function(RequestData, String?) onApproveComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ApproveRequestModalWidget(
          request: request,
          onApprove: (comments) {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModalWidget(
                  message:
                      '¿Está completamente seguro de que desea aprobar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: const Color(
                    0xFF00C48C,
                  ), // Verde para aprobar
                  confirmButtonText: 'Confirmar',
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    // Cerrar modal de confirmación
                    Navigator.of(context).pop();

                    // Paso 3: Mostrar resultado exitoso
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SuccessResultModalWidget(
                          title: 'Aprobación exitosa',
                          message:
                              'La solicitud ha sido aprobada correctamente.',
                          iconColor: const Color(
                            0xFF00C48C,
                          ), // Verde para éxito en aprobación
                          onAccept: () {
                            Navigator.of(context).pop();
                            onApproveComplete(request, comments);
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Método para mostrar flujo de rechazo
  static void showRejectionFlow({
    required BuildContext context,
    required RequestData request,
    required Function(RequestData, String) onRejectComplete,
  }) {
    // Paso 1: Mostrar modal de rechazo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RejectRequestModalWidget(
          request: request,
          onReject: (reason) {
            // Cerrar el primer modal
            Navigator.of(context).pop();

            // Paso 2: Mostrar confirmación
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModalWidget(
                  message:
                      '¿Está completamente seguro de que desea rechazar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: const Color(
                    0xFFFF5252,
                  ), // Rojo para rechazar
                  confirmButtonText: 'Confirmar',
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    // Cerrar modal de confirmación
                    Navigator.of(context).pop();

                    // Paso 3: Mostrar resultado exitoso
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SuccessResultModalWidget(
                          title: 'Rechazo exitoso',
                          message:
                              'La solicitud ha sido rechazada correctamente.',
                          iconColor: const Color(0xFFFF5252),
                          onAccept: () {
                            Navigator.of(context).pop();
                            onRejectComplete(request, reason);
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
