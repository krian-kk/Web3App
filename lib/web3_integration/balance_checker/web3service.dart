import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3Service {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _getBalance;

  final contractAddress = EthereumAddress.fromHex('0x2169dff7dc41371dce4a3de496c9c08af74ce5db');
  final String _rpcUrl =
      "https://sepolia.infura.io/v3/34ef393c55224fafb01a09013b616ac9"; // Replace with your Infura URL

  Web3Service() {
    _client = Web3Client(_rpcUrl, Client());
  }

  Future<void> initialize() async {
    // Load ABI from the assets
    String abiString = await rootBundle.loadString('/BalanceChecker.json');

    _contract = DeployedContract(
        ContractAbi.fromJson(abiString, "BalanceChecker"),
        EthereumAddress.fromHex('0x2169dff7dc41371dce4a3de496c9c08af74ce5db'));

    _getBalance = _contract.function('getBalance');
  }

  Future<BigInt> getBalance(String address) async {
    final result = await _client.call(
      contract: _contract,
      function: _getBalance,
      params: [EthereumAddress.fromHex(address)],
    );
    return result.first as BigInt;
  }
}
