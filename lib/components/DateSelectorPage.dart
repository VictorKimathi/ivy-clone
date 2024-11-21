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

  void _incrementPeriodValue() {
    setState(() {
      lastPeriodValue++;
    });
  }

  void _decrementPeriodValue() {
    setState(() {
      if (lastPeriodValue > 0) lastPeriodValue--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selection
            Text(
              'Choose month',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildMonthButton('October'),
                _buildMonthButton('November'),
                _buildMonthButton('December'),
              ],
            ),
            SizedBox(height: 20),

            // Custom Range Section
            Text(
              'or custom range',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10),
            _buildCustomRangePicker('From', 'Add date'),
            SizedBox(height: 10),
            _buildCustomRangePicker('To', 'Add date'),
            SizedBox(height: 20),

            // Last Period Section
            Text(
              'or in the last',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildPeriodInput(),
                SizedBox(width: 10),
                _buildPeriodUnitSelector(),
              ],
            ),
            SizedBox(height: 20),

            // All Time Selection
            Text(
              'or all time',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              onPressed: () {},
              child: Text(
                'Select All Time',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),

            // Set Button
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Set button action
                },
                child: Text(
                  'Set',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthButton(String month) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMonth = month;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedMonth == month ? Colors.purple : Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              month,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRangePicker(String label, String placeholder) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            placeholder,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodInput() {
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
            Text(
              '$lastPeriodValue',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _decrementPeriodValue,
                  child:
                      Icon(Icons.arrow_back_ios, color: Colors.grey, size: 14),
                ),
                GestureDetector(
                  onTap: _incrementPeriodValue,
                  child: Icon(Icons.arrow_forward_ios,
                      color: Colors.grey, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodUnitSelector() {
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
            Text(
              lastPeriodUnit,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
