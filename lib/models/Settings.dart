import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus(); // Remove the cursor from the search bar
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Slightly grey background color
        body: Padding(
          padding: const EdgeInsets.all(15.0), // Padding around the entire page
          child: SingleChildScrollView( // Fix overflow error by allowing scrolling
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Search Box
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search transaction', // Placeholder text
                      prefixIcon: Icon(Icons.search), // Icon properly aligned
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0), // Reduced border width
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0), // Black border when active
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                  ),
                ),
                // Heading
                const Text(
                  'Quick access',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),
                // First Row of Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularIcon(Icons.settings, 'Settings'),
                    _buildCircularIcon(Icons.category, 'Categories'),
                    _buildCircularIcon(Icons.light_mode, 'Light Mode'),
                    _buildCircularIcon(Icons.payment, 'Planned\nPayments'),
                  ],
                ),
                const SizedBox(height: 20),
                // Second Row of Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularIcon(Icons.offline_share_rounded, 'Share'),
                    _buildCircularIcon(Icons.my_library_books, 'Reports'),
                    _buildCircularIcon(Icons.attach_money, 'Dollar'),
                    _buildCircularIcon(Icons.account_balance, 'Loans'),
                  ],
                ),
                const SizedBox(height: 20),
                // Savings Goal
                const Row(
                  children: [
                    Text(
                      'Savings goal: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          ' KES',
                          style: TextStyle(fontSize: 19, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Red Button
                Container(
                  width: double.infinity,
                  height: 90, // Increased height by 10
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(20), // Border radius of 20px
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.white, size: 40,),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Buffer exceeded by',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '1000.0 KES',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // GitHub Button
                Container(
                  width: double.infinity,
                  height: 90, // Adjusted height for better visibility
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle, color: Colors.black, size: 40,),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ive Wallet is Open source',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Increased font size
                            ),
                            SizedBox(height: 10),
                            Text(
                              'GitHub Login link',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Implement action here
          },
          backgroundColor: Colors.white, // White background color
          child: const Icon(Icons.arrow_upward, color: Colors.black87), // Black icon color
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Move to the bottom right
      ),
    );
  }

  Widget _buildCircularIcon(IconData iconData, String label) {
    return GestureDetector(
      onTap: () {
        // Use the route parameter to navigate to the desired page
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: const ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.white,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(30), // Ensure the splash is circular
                onTap: () {
                  setState(() {
                    // Trigger the press effect
                  });
                },
                splashColor: Colors.grey[10], // Red color on press
                child: Padding(
                  padding: const EdgeInsets.all(15.0), // Adjust padding for a better effect
                  child: Icon(iconData, size: 27, color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
