import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mama/src/data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PdfView extends StatefulWidget {
  final String path;
  final String? title;
  
  const PdfView({
    super.key,
    required this.path,
    this.title,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  Uint8List? _pdfData;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });

      Uint8List? pdfData;
      
      if (widget.path.startsWith('http')) {
        // Network PDF
        final file = await DefaultCacheManager().getSingleFile(widget.path);
        pdfData = await file.readAsBytes();
      } else if (widget.path.startsWith('/') || widget.path.startsWith('file://')) {
        // Local file path
        final String filePath = widget.path.startsWith('file://')
            ? widget.path.replaceFirst('file://', '')
            : widget.path;
        final file = File(filePath);
        pdfData = await file.readAsBytes();
      } else {
        // Asset PDF (flutter assets)
        final data = await rootBundle.load(widget.path);
        pdfData = data.buffer.asUint8List();
      }

      if (mounted) {
        setState(() {
          _pdfData = pdfData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _onPageChanged(int? page, int? total) {
    if (mounted) {
      setState(() {
        _currentPage = page ?? 0;
        _totalPages = total ?? 0;
      });
    }
  }

  void _onViewCreated(PDFViewController controller) {
    // Controller is available for future use if needed
  }

  String _getDocumentTitle() {
    if (widget.title != null) return widget.title!;
    
    // Extract title from path
    final fileName = widget.path.split('/').last;
    if (fileName.contains('.')) {
      return fileName.split('.').first;
    }
    return 'Document';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getDocumentTitle(),
        leading: const CustomBackButton(),
        action: _totalPages > 0
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_pdfData == null) {
      return _buildErrorState(message: 'Failed to load PDF data');
    }

    return _buildPdfViewer();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading document...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.greyBrighterColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({String? message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load document',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? _errorMessage ?? 'An unexpected error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.greyBrighterColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPdf,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    return PDFView(
      pdfData: _pdfData!,
      onViewCreated: _onViewCreated,
      onPageChanged: _onPageChanged,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      onRender: (pages) {
        if (mounted) {
          setState(() {
            _totalPages = pages ?? 0;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = error.toString();
          });
        }
      },
      onPageError: (page, error) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Error loading page $page: ${error.toString()}';
          });
        }
      },
    );
  }
}
