import 'package:flutter/material.dart';
import 'package:demo_app_2/widgets/mydrawer.widget.dart';

class ContactsPage extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {
      'name': 'MOUHIM Meryem',
      'email': 'meryemmouhim@gmail.com',
      'phone': '+212 623456789'
    },
    {
      'name': 'Laila makhlouf',
      'email': 'lailamakhlouf@gmail.com',
      'phone': '+333 123456789'
    },
    {
      'name': 'Tanime Jafir',
      'email': 'TasnileJafir@gmail.com',
      'phone': '+331 734510290'
    },

    {
      'name': 'Youssra Farah',
      'email': 'youssrafarah@gmail.com',
      'phone': '+514 930123980'
    },
    {
      'name': 'Karim Benali',
      'email': 'karim.benali@gmail.com',
      'phone': '+212 654321987'
    },
    {
      'name': 'Salma El Fassi',
      'email': 'salma.elfassi@gmail.com',
      'phone': '+212 612345678'
    },
    {
      'name': 'Omar Naji',
      'email': 'omar.naji@gmail.com',
      'phone': '+212 698765432'
    },
    {
      'name': 'Imane Rami',
      'email': 'imane.rami@gmail.com',
      'phone': '+212 601234567'
    },
    {
      'name': 'Yassine Idrissi',
      'email': 'yassine.idrissi@gmail.com',
      'phone': '+212 677889900'
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: const Text("Contacts")),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final initials = contact['name']!.split(' ').map((e) => e[0]).join();

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Text(
                  initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(contact['name']!),
              subtitle: Text("${contact['email']}\n${contact['phone']}"),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}
