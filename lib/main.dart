import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? playerAChoice;
  String? playerBChoice;
  String? result;
  bool playerATurn = true;
  int countdown = 3;
  Timer? timer;

  void _play(String choice) {
    if (playerATurn) {
      setState(() {
        playerAChoice = choice;
        playerATurn = false;
      });
    } else {
      setState(() {
        playerBChoice = choice;
        _startCountdown();
      });
    }
  }

  void _startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          timer.cancel();
          _calculateResult();
        }
      });
    });
  }

  void _calculateResult() {
    if (playerAChoice == playerBChoice) {
      result = "It's a tie!";
    } else if ((playerAChoice == '✊' && playerBChoice == '✌️') ||
        (playerAChoice == '✋' && playerBChoice == '✊') ||
        (playerAChoice == '✌️' && playerBChoice == '✋')) {
      result = "Player A wins!";
    } else {
      result = "Player B wins!";
    }
    setState(() {});
  }

  void _restartGame() {
    setState(() {
      playerAChoice = null;
      playerBChoice = null;
      result = null;
      playerATurn = true;
      countdown = 3;
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Transform.rotate(
                angle: pi,
                child: _buildPlayerAView(),
              ),
            ),
            const Divider(height: 5, color: Colors.black),
            Expanded(
              child: _buildPlayerBView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerAView() {
    if (result != null) {
      return _buildResultView(playerAChoice, "Player A");
    }
    if (playerATurn) {
      return _buildChoiceView("Player A");
    } else {
      return _buildWaitingView("Player A");
    }
  }

  Widget _buildPlayerBView() {
    if (result != null) {
      return _buildResultView(playerBChoice, "Player B");
    }
    if (!playerATurn && playerBChoice == null) {
      return _buildChoiceView("Player B");
    } else if (playerBChoice != null) {
      return _buildCountdownView();
    } else {
      return _buildWaitingView("Player B");
    }
  }

  Widget _buildChoiceView(String player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          player,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChoiceButton('✊'),
            _buildChoiceButton('✋'),
            _buildChoiceButton('✌️'),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String choice) {
    return ElevatedButton(
      onPressed: () => _play(choice),
      child: Text(
        choice,
        style: const TextStyle(fontSize: 50),
      ),
    );
  }

  Widget _buildWaitingView(String player) {
    return Center(
      child: Text(
        "Waiting for ${player == "Player A" ? "Player B" : "Player A"}",
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildCountdownView() {
    return Center(
      child: Text(
        '$countdown',
        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildResultView(String? choice, String player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          player,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          choice ?? '',
          style: const TextStyle(fontSize: 50),
        ),
        const SizedBox(height: 20),
        if (player == "Player B") ...[
          Text(
            result ?? '',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _restartGame,
            child: const Text("Restart"),
          ),
        ]
      ],
    );
  }
}