// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final Function(String)? onSearch;
  final Function()? onSearchClear;
  final bool hasDrawer;
  final List<Widget>? additionalActions;
  final Function(String)? onScanOption;

  const SearchAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSearch,
    this.onSearchClear,
    this.hasDrawer = true,
    this.additionalActions,
    this.onScanOption,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with TickerProviderStateMixin {
  bool _isSearching = false;
  bool _isFilterExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterRotationAnimation;
  // ignore: unused_field
  late Animation<Offset> _filterSlideAnimation;

  Timer? _debounceTimer;

  OverlayEntry? _overlayEntry;
  final GlobalKey _filterButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _filterAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _filterSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _filterAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _searchController.addListener(() {
      setState(() {});
    });

    _filterAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _filterAnimationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _isFilterExpanded = false;
    });
    _animationController.forward();
    _filterAnimationController.reverse();
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _isFilterExpanded = false;
    });
    _animationController.reverse();
    _filterAnimationController.reverse();
    _searchFocusNode.unfocus();
    if (widget.onSearchClear != null) {
      widget.onSearchClear!();
    }
  }

  void _toggleFilter() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });

    if (_isFilterExpanded) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _overlayEntry = _createFilterOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        _filterAnimationController.forward();
      });
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _handleScanOption(String option) {
    setState(() {
      _isFilterExpanded = false;
    });
    _filterAnimationController.reverse();
    if (widget.onScanOption != null) {
      widget.onScanOption!(option);
    }
  }

  OverlayEntry _createFilterOverlayEntry() {
    final RenderBox renderBox =
        _filterButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            right: MediaQuery.of(context).size.width - (offset.dx + size.width),
            top: offset.dy + size.height + 8.0,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: _filterAnimationController,
                child: FadeTransition(
                  opacity: _filterAnimationController,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildScanOption(
                          'Número de serie',
                          Icons.qr_code_scanner,
                          Colors.red,
                          () => _handleScanOption('serial'),
                        ),
                        _buildScanOption(
                          'Entrada de código',
                          Icons.keyboard,
                          Colors.blue,
                          () => _handleScanOption('manual'),
                        ),
                        _buildScanOption(
                          'Escanear código',
                          Icons.qr_code,
                          Colors.green,
                          () => _handleScanOption('scan'),
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

  Widget _buildScanOption(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Buscar...',
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearchText,
                )
                : null,
      ),
      onChanged: _onSearchChanged,
      onSubmitted: _performSearch,
      textInputAction: TextInputAction.search,
    );
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
      backgroundColor: _isSearching ? Colors.grey[100] : Colors.white,
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
                icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
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
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 24,
                  ),
                  onPressed: _stopSearch,
                ),
                const SizedBox(width: 8),
              ]
              : [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue, size: 25),
                  onPressed: _startSearch,
                ),
                AnimatedBuilder(
                  animation: _filterAnimationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _filterRotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        key: _filterButtonKey,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              _isFilterExpanded
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFilterExpanded
                                ? Icons.close
                                : Icons.filter_alt_outlined,
                            color:
                                _isFilterExpanded ? Colors.orange : Colors.blue,
                            size: 25,
                          ),
                          onPressed: _toggleFilter,
                          tooltip:
                              _isFilterExpanded
                                  ? 'Cerrar opciones'
                                  : 'Opciones de escaneo',
                        ),
                      ),
                    );
                  },
                ),
                ...?widget.additionalActions,
              ],
    );
  }
}
