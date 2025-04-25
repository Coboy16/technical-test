import 'package:flutter/material.dart';
import 'package:technical_test/presentation/feactures/requests/views/views.dart';
import 'package:technical_test/presentation/widgets/sidebar/sidebar_widget.dart';
import 'package:technical_test/presentation/widgets/widgets.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Sidebar a la izquierda ---
          const SidebarWidget(),

          // --- Contenido Principal a la derecha ---
          Expanded(
            child: Column(
              children: [
                // --- Header en la parte superior del contenido ---
                const HeaderWidget(),

                // --- Área de contenido principal ---
                Expanded(
                  child:
                      _isLoading
                          ? const RequestsContentShimmer()
                          : const RequestsContentView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
