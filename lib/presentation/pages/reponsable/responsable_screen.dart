
import 'package:distra_aft/config/utils/custom_context.dart';
import 'package:distra_aft/presentation/widgets/app_drawer.dart';
import 'package:distra_aft/presentation/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsablePage extends StatefulWidget {
  const ResponsablePage({super.key});

  @override
  State<ResponsablePage> createState() => _ResponsablePageState();
}

class _ResponsablePageState extends State<ResponsablePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _responsibleCount = 156;
  String _searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/verification'); // Ir a página principal
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Responsables',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$_responsibleCount responsables',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 25,
                itemBuilder: (context, index) {
                  final responsibleName = 'Responsable ${index + 1}';
                  final shouldShow =
                      _searchQuery.isEmpty ||
                      responsibleName.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );

                  if (!shouldShow) return const SizedBox.shrink();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF3F51B5,
                        ).withOpacity(0.2),
                        child: const Icon(
                          Icons.people,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      title: Text(responsibleName),
                      subtitle: Text('Cargo del responsable ${index + 1}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
