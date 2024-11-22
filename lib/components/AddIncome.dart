import 'package:flutter/material.dart';
import 'package:ivywallet/models/Accounts.dart';
 // Ensure the Account class is correctly imported

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  Future<List<Account>> fetchAccounts() async {
    return await Account.getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Account>>(
        future: fetchAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching accounts"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No accounts found"));
          } else {
            final accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        account.name[0], // First letter of the account name
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(account.name),
                    subtitle: Text("Balance: KES ${account.balance.toStringAsFixed(2)}"),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


