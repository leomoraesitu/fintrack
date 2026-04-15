import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Switch padrão do Design System FinTrack
///
/// Variantes: Android, iOS, iOS 2.6+
/// Estados: ativo/inativo
/// Parâmetro opcional de label
class FtSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final FtSwitchVariant variant;
  final String? label;

  const FtSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.variant = FtSwitchVariant.android,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Widget switchWidget;
    switch (variant) {
      case FtSwitchVariant.android:
        switchWidget = Switch(
          value: value,
          onChanged: onChanged,
        );
        break;
      case FtSwitchVariant.ios:
        switchWidget = CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        );
        break;
      case FtSwitchVariant.ios26:
        switchWidget = CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          trackColor: Colors.black26,
          activeColor: Colors.blueAccent,
        );
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switchWidget,
        if (label != null) ...[
          const SizedBox(width: 12),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

enum FtSwitchVariant { android, ios, ios26 }
