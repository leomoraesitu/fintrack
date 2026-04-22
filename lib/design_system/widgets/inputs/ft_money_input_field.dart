import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyInputField extends StatefulWidget {
  const MoneyInputField({super.key});

  @override
  State<MoneyInputField> createState() => _MoneyInputFieldState();
}

class _MoneyInputFieldState extends State<MoneyInputField> {
  final TextEditingController _controller = TextEditingController();
  final NumberFormat _formatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');


  void _onChanged(String text) {
    String numbersOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbersOnly.isEmpty) {
      setState(() {
        _controller.text = '';
      });
      return;
    }

    double parsed = double.parse(numbersOnly) / 100;

    final newText = _formatter.format(parsed);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return Center(
      child: IntrinsicWidth(
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: _onChanged,
          textAlign: TextAlign.center,
          style: style,
          decoration: const InputDecoration(
            hintText: 'R\$ 0,00',
            border: InputBorder.none,
            isCollapsed: true,
            filled: false,
          ),
        ),
      ),
    );
  }
}