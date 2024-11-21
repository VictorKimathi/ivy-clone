import 'package:flutter/material.dart';
import 'DateSelectorPage.dart';

class TransactionSummary extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<TransactionSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Container(
            width: 150.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 238, 240, 239),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DateSelectorPage()),
                );
              },
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers the row horizontally
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centers the items vertically
                children: [
                  Icon(Icons.calendar_today, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    'November', // Placeholder for month text
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.teal),
            onPressed: () {},
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // Space between AppBar and "Income" text
            Text(
              'Income',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '0.00 KES',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.download, size: 32, color: Colors.grey),
                      onPressed: () {
                        // Add download functionality here
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32), // Space at the bottom
          ],
        ),
      ),
    );
  }
}
