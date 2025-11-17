import 'package:flutter/material.dart';
import 'drawing_controller.dart';

class DrawingToolbar extends StatefulWidget {
  final DrawingController drawingController;

  const DrawingToolbar({
    Key? key,
    required this.drawingController,
  }) : super(key: key);

  @override
  State<DrawingToolbar> createState() => _DrawingToolbarState();
}

class _DrawingToolbarState extends State<DrawingToolbar> {
  @override
  void initState() {
    super.initState();
    widget.drawingController.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.drawingController.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              widget.drawingController.isDrawingMode
                  ? Icons.edit_off
                  : Icons.edit,
              size: 20,
            ),
            onPressed: () {
              widget.drawingController.toggleDrawingMode();
            },
            tooltip: widget.drawingController.isDrawingMode
                ? 'Disable Drawing'
                : 'Enable Drawing',
          ),
          if (widget.drawingController.selectedDrawing != null)
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
              onPressed: () {
                widget.drawingController.deleteSelectedDrawing();
              },
              tooltip: 'Delete Selected Line',
            ),
        ],
      ),
    );
  }
}

