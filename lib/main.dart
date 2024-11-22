import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivywallet/pages/DateSelectorPage.dart';
import 'package:ivywallet/pages/HomeScreen.dart';
import 'package:ivywallet/pages/TransactionAdd.dart';
import 'components/AddIncome.dart';
import 'models/Accounts.dart';
import 'models/Settings.dart';
import 'pages/Accounts.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // FirebaseOptions are passed here
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinanceAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const AccountView(),
    // Other pages can be added here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleFabAction(BuildContext context) {
    if (_selectedIndex == 0) {
      // Show popup menu for Add Expense/Add Income
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100, MediaQuery.of(context).size.height - 200, 100, 100),
        items: [
          const PopupMenuItem(
            value: 'add_expense',
            child: Text('Add Expense'),
          ),
          const PopupMenuItem(
            value: 'add_income',
            child: Text('Add Income'),
          ),
        ],
      ).then((value) {
        if (value == 'add_expense' || value == 'add_income') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentScreen()),
          );
        }
      });
    } else if (_selectedIndex == 1) {
      // Show modal bottom sheet for Add Account
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _AddAccountForm(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFabAction(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.deepPurpleAccent : Colors.grey,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            const SizedBox(width: 48), // Placeholder for the FAB notch
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: _selectedIndex == 1 ? Colors.deepPurpleAccent : Colors.grey,
              ),
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAccountForm extends StatefulWidget {
  @override
  _AddAccountFormState createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<_AddAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final account = Account(
      id: FirebaseFirestore.instance.collection('accounts').doc().id,
      name: _nameController.text,
      balance: double.tryParse(_balanceController.text) ?? 0.0,
    );

    try {
      await account.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully')),
      );
      Navigator.pop(context); // Close the modal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding account: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Account Name', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Enter an account name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _balanceController,
            decoration:
            const InputDecoration(labelText: 'Initial Balance', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator:(value){
              if (value == null || value.isEmpty) return 'Enter a balance';
              if (double.tryParse(value) == null) return 'Enter a valid number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:_isLoading ? null :_saveAccount ,
            child:_isLoading
                ?const CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(Colors.white),)
                :const Text('Save'),
          ),
        ],
      ),
    );
  }
}
