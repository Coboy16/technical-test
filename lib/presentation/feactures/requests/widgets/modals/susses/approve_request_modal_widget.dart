import 'package:flutter/material.dart';

import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/request_action_modal_widget.dart';

class ApproveRequestModal extends StatefulWidget {
  final RequestData request;
  final Function(RequestData, String?) onApprove;
  final VoidCallback onCancel;

  const ApproveRequestModal({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onCancel,
  });

  @override
  State<ApproveRequestModal> createState() => _ApproveRequestModalState();
}

class _ApproveRequestModalState extends State<ApproveRequestModal> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RequestActionModal(
      title: 'Aprobar solicitud',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mensaje de confirmación
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              children: [
                const TextSpan(text: '¿Está seguro que desea '),
                TextSpan(
                  text: 'APROBAR',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' la solicitud de vacaciones de '),
                TextSpan(
                  text: widget.request.employeeName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Campo de comentarios
          const Text(
            'Comentarios (opcional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _commentsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Añada comentarios adicionales si lo desea...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
      confirmButtonText: 'Aprobar',
      confirmButtonColor: Colors.blue,
      onCancel: widget.onCancel,
      onConfirm: () {
        widget.onApprove(widget.request, _commentsController.text);
      },
    );
  }
}
