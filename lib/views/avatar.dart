import 'package:flutter/material.dart';
import 'package:just_share/logger/logger.dart';
import 'package:just_share/src/rust/api/command.dart';

class BreathingCircleAvatar extends StatefulWidget {
  final double avatarCircleSize;
  final double circleAvatarScale;
  final Function(DiscoveryIp) selectedHandler;
  final DiscoveryIp discoveryIp;
  const BreathingCircleAvatar(
      {super.key,
      required this.avatarCircleSize,
      required this.circleAvatarScale,
      required this.selectedHandler,
      required this.discoveryIp});

  @override
  _BreathingCircleAvatarState createState() => _BreathingCircleAvatarState();
}

class _BreathingCircleAvatarState extends State<BreathingCircleAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _radius = widget.avatarCircleSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Handle the tap event
            widget.selectedHandler(widget.discoveryIp);
          },
          child: Tooltip(
            message: widget.discoveryIp.addr,
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: _radius * _controller.value + 10,
              // radius: 20,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.discoveryIp.hostname,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateRadius();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3), lowerBound: 0.5)
      ..repeat(reverse: true);
  }

  void updateRadius() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    _radius = (width > height ? height : width) * widget.circleAvatarScale;
    logger.d("update radius $_radius");
  }
}
