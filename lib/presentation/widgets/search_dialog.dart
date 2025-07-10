import 'dart:async';
import 'package:distra_aft/config/utils/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:dsimcaf_1/config/utils/custom_context.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final Function(String)? onSearch;
  final Function()? onSearchClear;
  final bool hasDrawer;
  final List<Widget>? additionalActions;

  const SearchAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSearch,
    this.onSearchClear,
    this.hasDrawer = true,
    this.additionalActions,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    _animationController.reverse();
    _searchFocusNode.unfocus();
    if (widget.onSearchClear != null) {
      widget.onSearchClear!();
    }
  }

  void _clearSearchText() {
    _searchController.clear();
    _debounceTimer?.cancel();
    _performSearch('');
    _searchFocusNode.requestFocus();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (widget.onSearch != null) {
      widget.onSearch!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _isSearching ? Colors.grey[100] : context.background,
      elevation: 0,
      leading:
          _isSearching
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                  size: 24,
                ),
                onPressed: _stopSearch,
              )
              : widget.hasDrawer
              ? IconButton(
                icon: Icon(Icons.menu, color: context.primary, size: 28),
                onPressed: widget.onMenuPressed,
              )
              : null,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _isSearching ? _buildSearchField() : _buildTitle(),
      ),
      centerTitle: !_isSearching,
      actions:
          _isSearching
              ? [
                // Botón externo - cierra el buscador completamente
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 24,
                  ),
                  onPressed: _stopSearch, // Cierra el buscador
                ),
                const SizedBox(width: 8),
              ]
              : [
                IconButton(
                  icon: Icon(Icons.search, color: context.primary, size: 28),
                  onPressed: _startSearch,
                ),
                ...?widget.additionalActions,
              ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      key: const ValueKey('title'),
      style: TextStyle(
        color: context.primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      key: const ValueKey('search'),
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          // Elimina todos los bordes
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.search, color: Colors.grey[600], size: 18),
          ),
          // Botón interno - solo limpia el texto
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _clearSearchText, // Solo limpia el texto
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                  : null,
        ),
        onChanged: _onSearchChanged,
        onSubmitted: _performSearch,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
