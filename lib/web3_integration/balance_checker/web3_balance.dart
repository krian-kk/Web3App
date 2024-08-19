import 'package:flutter/material.dart';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:web3app/web3_integration/balance_checker/web3service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Web3Service _web3Service = Web3Service();
  BigInt? _balance;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _web3Service.initialize();
  }

  void _fetchBalance() async {
    setState(() {
      _loading = true;
    });

    final balance = await _web3Service.getBalance(walletAddress);

    setState(() {
      _balance = balance;
      _loading = false;
    });
  }

  String walletAddress = '';
  bool isConnected = false;

  Future<void> connectMetaMask() async {
    if (ethereum != null) {
      try {
        final accounts = await ethereum!.requestAccount();
        final account = accounts.first;
        setState(() {
          walletAddress = account;
          isConnected = true;
          _fetchBalance();
        });
      } catch (e) {
        print("Error connecting to MetaMask: $e");
      }
    } else {
      print("MetaMask is not available in this browser.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Ethereum Balance Checker')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: connectMetaMask,
                  child: const Text('Get Balance'),
                ),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : _balance != null
                        ? Text('Balance: ${_balance.toString()} wei')
                        : const Text('No balance fetched yet'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
