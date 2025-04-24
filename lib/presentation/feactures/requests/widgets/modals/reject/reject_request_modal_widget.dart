import 'package:flutter/material.dart';
import 'package:technical_test/presentation/feactures/requests/temp/mock_data.dart';
import 'package:technical_test/presentation/feactures/requests/widgets/modals/request_action_modal_widget.dart';

class RejectRequestModal extends StatefulWidget {
  final RequestData request;
  final Function(RequestData, String) onReject;
  final VoidCallback onCancel;

  const RejectRequestModal({
    super.key,
    required this.request,
    required this.onReject,
    required this.onCancel,
  });

  @override
  State<RejectRequestModal> createState() => _RejectRequestModalState();
}

class _RejectRequestModalState extends State<RejectRequestModal> {
  final TextEditingController _reasonController = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_reasonController.text.trim().isEmpty) {
      setState(() {
        _hasError = true;
      });
    } else {
      widget.onReject(widget.request, _reasonController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RequestActionModal(
      title: 'Rechazar solicitud',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mensaje de confirmación
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: '¿Está seguro que desea '),
                TextSpan(
                  text: 'RECHAZAR',
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

          // Campo de motivo de rechazo
          const Text(
            'Motivo del rechazo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Indique el motivo del rechazo...',
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
                borderSide: const BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              errorText: _hasError ? 'Este campo es obligatorio' : null,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) {
              if (_hasError && value.trim().isNotEmpty) {
                setState(() {
                  _hasError = false;
                });
              }
            },
          ),
        ],
      ),
      confirmButtonText: 'Rechazar',
      confirmButtonColor: Colors.red,
      onCancel: widget.onCancel,
      onConfirm: _validateAndSubmit,
    );
  }
}
