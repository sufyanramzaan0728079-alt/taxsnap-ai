import 'package:flutter/material.dart';

void main() => runApp(const TaxSnapApp());

class TaxSnapApp extends StatelessWidget {
  const TaxSnapApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaxSnap AI',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class Receipt {
  String vendor; double total; String category; String date;
  Receipt(this.vendor, this.total, this.category, this.date);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Receipt> receipts = [
    Receipt('Costa Coffee', 4.50, 'Meals', '08 Nov 2026'),
    Receipt('【entity-Tesco¦canonical_name=Tesco】', 12.00, 'Office Costs', '08 Nov 2026'),
  ];
  int scansLeft = 10;

  double get totalSpent => receipts.fold(0, (s, r) => s + r.total);
  double get taxSaved => totalSpent * 0.20;

  void _addDemo() {
    setState(() {
      receipts.insert(0, Receipt('【entity-Starbucks¦canonical_name=Starbucks】', 5.20, 'Meals', '08 Nov 2026'));
      if (scansLeft > 0) scansLeft--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TaxSnap AI'), backgroundColor: Colors.green, foregroundColor: Colors.white, actions: [Padding(padding: const EdgeInsets.all(12), child: Chip(label: Text('$scansLeft Free Left')))]),
      body: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(16), color: Colors.green.shade50, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('YOU SAVED!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('£${taxSaved.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
          Text('Total Spent: £${totalSpent.toStringAsFixed(2)}  •  ${receipts.length} Receipts  •  HMRC MTD Ready'),
        ])),
        Expanded(child: ListView.builder(itemCount: receipts.length, itemBuilder: (c, i) {
          final r = receipts[i];
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: ListTile(leading: const Icon(Icons.receipt, color: Colors.green), title: Text(r.vendor), subtitle: Text('${r.category} • ${r.date}'), trailing: Text('£${r.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))));
        })),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: _addDemo, icon: const Icon(Icons.camera_alt), label: const Text('SCAN RECEIPT')),
    );
  }
}
