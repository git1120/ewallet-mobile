import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

class IbaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IbaAppBar({required this.title, this.actions, this.leading, super.key});
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: Text(title), actions: actions, leading: leading);
}

class IbaPageScaffold extends StatelessWidget {
  const IbaPageScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.bottomNavigationBar,
    super.key,
  });
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: IbaAppBar(title: title, actions: actions),
    bottomNavigationBar: bottomNavigationBar,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: IbaBreakpoints.medium),
          child: body,
        ),
      ),
    ),
  );
}
