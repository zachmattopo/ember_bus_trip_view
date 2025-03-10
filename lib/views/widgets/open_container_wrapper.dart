import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// This widget is used to animate the opening and closing of cards
/// with container transform animation.
class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({required this.openedChild, required this.closedChild, super.key});

  /// Page to push after tapping the container (no need `Navigator.push` command
  /// as navigation is handled internally by the package).
  final Widget openedChild;

  /// Container when the page is in closed state.
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OpenContainer<Map>(
      closedBuilder: (context, openContainer) {
        return InkWell(onTap: () => openContainer(), child: closedChild);
      },
      closedColor: theme.cardColor,
      closedElevation: 2,
      openBuilder: (context, closedContainer) {
        return openedChild;
      },
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
