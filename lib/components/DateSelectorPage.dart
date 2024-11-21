import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DateSelectorPage(),
      theme: ThemeData.dark(),
    );
  }
}

class DateSelectorPage extends StatefulWidget {
  @override
  _DateSelectorPageState createState() => _DateSelectorPageState();
}

class _DateSelectorPageState extends State<DateSelectorPage> {
  String selectedMonth = 'November';
  int lastPeriodValue = 0;
  String lastPeriodUnit = 'Weeks';

  void _incrementPeriodValue() => setState(() => lastPeriodValue++);
  void _decrementPeriodValue() =>
      setState(() => lastPeriodValue = lastPeriodValue > 0 ? lastPeriodValue - 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Choose month'),
            SizedBox(height: 10),
            Row(
              children: ['October', 'November', 'December']
                  .map((month) => _MonthButton(
                month: month,
                isSelected: selectedMonth == month,
                onTap: () => setState(() => selectedMonth = month),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            _SectionTitle(title: 'or custom range', isSecondary: true),
            SizedBox(height: 10),
            _CustomRangePicker(label: 'From', placeholder: 'Add date'),
            SizedBox(height: 10),
            _CustomRangePicker(label: 'To', placeholder: 'Add date'),
            SizedBox(height: 20),
            _SectionTitle(title: 'or in the last', isSecondary: true),
            SizedBox(height: 10),
            Row(
              children: [
                _PeriodInput(
                  value: lastPeriodValue,
                  onIncrement: _incrementPeriodValue,
                  onDecrement: _decrementPeriodValue,
                ),
                SizedBox(width: 10),
                _DropdownSelector(
                  currentValue: lastPeriodUnit,
                  items: ['Days', 'Weeks', 'Months'],
                  onChange: (newUnit) =>
                      setState(() => lastPeriodUnit = newUnit),
                ),
              ],
            ),
            SizedBox(height: 20),
            _SectionTitle(title: 'or all time', isSecondary: true),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              onPressed: () {},
              child: Text('Select All Time', style: TextStyle(color: Colors.white)),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text('Set', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isSecondary;

  const _SectionTitle({required this.title, this.isSecondary = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isSecondary ? Colors.grey : Colors.white,
        fontSize: isSecondary ? 16 : 20,
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  final String month;
  final bool isSelected;
  final VoidCallback onTap;

  const _MonthButton({
    required this.month,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple : Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              month,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomRangePicker extends StatelessWidget {
  final String label;
  final String placeholder;

  const _CustomRangePicker({required this.label, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(placeholder, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _PeriodInput extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _PeriodInput({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$value', style: TextStyle(color: Colors.white)),
            Row(
              children: [
                GestureDetector(
                  onTap: onDecrement,
                  child: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 14),
                ),
                GestureDetector(
                  onTap: onIncrement,
                  child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownSelector extends StatelessWidget {
  final String currentValue;
  final List<String> items;
  final ValueChanged<String> onChange;

  const _DropdownSelector({
    required this.currentValue,
    required this.items,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButton<String>(
        value: currentValue,
        isExpanded: true,
        dropdownColor: Colors.grey[800],
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: Container(),
        style: TextStyle(color: Colors.white),
        onChanged: onChange,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
