import 'package:flutter/material.dart';

// Contact model
class Contact {
  final String name;
  final String phone;
  final String email;

  const Contact({required this.name, required this.phone, required this.email});
}

// Sample contacts
const contacts = [
  Contact(name: 'Ali', phone: '+998 90 123 45 67', email: 'ali@example.com'),
  Contact(name: 'Vali', phone: '+998 91 234 56 78', email: 'vali@example.com'),
  Contact(
    name: 'Aziza',
    phone: '+998 93 345 67 89',
    email: 'aziza@example.com',
  ),
  Contact(
    name: 'Madina',
    phone: '+998 94 456 78 90',
    email: 'madina@example.com',
  ),
  Contact(
    name: 'Sardor',
    phone: '+998 95 567 89 01',
    email: 'sardor@example.com',
  ),
];

void main() {
  runApp(const MaterialApp(home: ContactListScreen()));
}

// Screen 1: Contact list
class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView(
        children: [
          for (final contact in contacts)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(contact.name),
              subtitle: Text(contact.phone),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactScreen(contact: contact),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Screen 2: Contact details
class ContactScreen extends StatelessWidget {
  final Contact contact;

  const ContactScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),

                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(contact.phone),
                ),

                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(contact.email),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
