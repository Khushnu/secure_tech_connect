import 'package:flutter/material.dart';
import 'dart:async';

class ConsoleScreen extends StatefulWidget {
  @override
  _ConsoleScreenState createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _output = [];
  final ScrollController _scrollController = ScrollController();
  bool _isReadyForInput = false;

  @override
  void initState() {
    super.initState();
    _initializeConsole();
  }

  void _initializeConsole() async {
    await _addOutput("Waiting for connection...");
    await Future.delayed(Duration(seconds: 2));
    await _addOutput("Server connecting...");
    await Future.delayed(Duration(seconds: 2));
    await _addOutput("Third server connected...");
    await Future.delayed(Duration(seconds: 2));
    await _addOutput("Connection successful.");
    await Future.delayed(Duration(seconds: 1));
    await _addOutput("Enter command:");
    setState(() {
      _isReadyForInput = true;
    });
  }

  Future<void> _addOutput(String message) async {
    setState(() {
      _output.add(message);
    });
    _scrollToBottom();
  }

  void _executeCommand(String command) async {
    if (!_isReadyForInput) return;
    await _addOutput('> $command');
    _controller.clear();
    
    await Future.delayed(Duration(seconds: 1));
    await _addOutput("Authorizing...");
    await Future.delayed(Duration(seconds: 2));
    await _addOutput("Please enter authentication key:");
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _output.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _output[index],
                          key: ValueKey<int>(index),
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Courier New',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Colors.black,
            child: Row(
              children: [
                Text('>', style: TextStyle(color: Colors.green, fontFamily: 'Courier New')),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.green, fontFamily: 'Courier New'),
                    cursorColor: Colors.green,
                    decoration: InputDecoration(border: InputBorder.none),
                    onSubmitted: _executeCommand,
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
