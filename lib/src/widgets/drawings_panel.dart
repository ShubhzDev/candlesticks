import 'package:candlesticks/src/models/candle_sticks_style.dart';
import 'package:candlesticks/src/models/drawing.dart';
import 'package:flutter/material.dart';

class DrawingsPanel extends StatefulWidget {
  const DrawingsPanel({
    Key? key,
    required this.drawings,
    required this.style,
  }) : super(key: key);

  final List<Drawing> drawings;
  final CandleSticksStyle style;

  @override
  State<DrawingsPanel> createState() => _DrawingsPanelState();
}

class _DrawingsPanelState extends State<DrawingsPanel> {
  bool showDrawingNames = false;

  @override
  Widget build(BuildContext context) {
    if (widget.drawings.isEmpty) return Container();

    return DefaultTextStyle(
      style: TextStyle(color: widget.style.primaryTextColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showDrawingNames || widget.drawings.length == 1
              ? Column(
                  children: widget.drawings
                      .map(
                        (e) => _PanelButton(
                          child: Row(
                            children: [
                              Icon(
                                Icons.show_chart,
                                size: 14,
                                color: widget.style.primaryTextColor,
                              ),
                              SizedBox(width: 5),
                              Text(e.name, style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          borderColor: widget.style.borderColor,
                        ),
                      )
                      .toList(),
                )
              : Container(),
          widget.drawings.length > 1
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showDrawingNames = !showDrawingNames;
                    });
                  },
                  child: _PanelButton(
                    borderColor: widget.style.borderColor,
                    child: Row(
                      children: [
                        Icon(Icons.show_chart,
                            size: 14, color: widget.style.primaryTextColor),
                        SizedBox(width: 5),
                        Icon(
                            showDrawingNames
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: widget.style.primaryTextColor),
                        Text(widget.drawings.length.toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    Key? key,
    required this.child,
    required this.borderColor,
  }) : super(key: key);

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
