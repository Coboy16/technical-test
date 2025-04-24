import 'package:flutter/material.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/reject/reject_request_modal_widget.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/susses/approve_request_modal_widget.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/susses/confirm_action_modal_widget.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/susses/success_result_modal_widget.dart';

class RequestActionHandler {
  // Método para mostrar flujo de aprobación
  static void showApprovalFlow({
    required BuildContext context,
    required RequestData request,
    required Function(RequestData, String?) onApproveComplete,
  }) {
    // Paso 1: Mostrar modal de aprobación
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ApproveRequestModal(
          request: request,
          onApprove: (request, comments) {
            // Cerrar el primer modal
            Navigator.of(context).pop();

            // Paso 2: Mostrar confirmación
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModal(
                  message:
                      '¿Está completamente seguro de que desea aprobar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: Colors.blue,
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
                        return SuccessResultModal(
                          title: 'Aprobación exitosa',
                          message:
                              'La solicitud ha sido aprobada correctamente.',
                          iconColor: Colors.green,
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
        return RejectRequestModal(
          request: request,
          onReject: (request, reason) {
            // Cerrar el primer modal
            Navigator.of(context).pop();

            // Paso 2: Mostrar confirmación
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ConfirmActionModal(
                  message:
                      '¿Está completamente seguro de que desea rechazar esta solicitud? Esta acción no se puede deshacer.',
                  confirmButtonColor: Colors.red,
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
                        return SuccessResultModal(
                          title: 'Rechazo exitoso',
                          message:
                              'La solicitud ha sido rechazada correctamente.',
                          iconColor: Colors.red,
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
