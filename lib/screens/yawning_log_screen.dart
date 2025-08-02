import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class YawningLogScreen extends StatefulWidget {
  const YawningLogScreen({super.key});

  @override
  _YawningLogScreenState createState() => _YawningLogScreenState();
}

class _YawningLogScreenState extends State<YawningLogScreen> {
  List<String> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStoredLogs(); // Load stored logs first
    fetchYawningLogs();
  }

  // Load logs from local storage
  Future<void> loadStoredLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      logs = prefs.getStringList('yawning_logs') ?? [];
    });
  }

  // Save logs to local storage
  Future<void> saveLogsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('yawning_logs', logs);
  }

  // Fetch logs from Flask server
  Future<void> fetchYawningLogs() async {
    try {
      final String apiUrl = 'http://172.30.103.226:5000/api/yawning_logs';
      print("Fetching yawning logs from: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded JSON Response: $data");

        if (data.containsKey('logs')) {
          setState(() {
            // Append new logs without duplication
            List<String> newLogs = List<String>.from(data['logs']);
            for (String log in newLogs) {
              if (!logs.contains(log)) {
                logs.add(log);
              }
            }
            isLoading = false;
          });

          // Save updated logs to local storage
          saveLogsToLocal();
          print("Yawning logs fetched successfully: $logs");
        } else {
          print("Error: 'logs' key not found in response");
        }
      } else {
        print(
          "Error: Failed to load logs, Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error fetching logs: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1F31),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "YAWNING LOG",
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : logs.isEmpty
              ? const Center(
                child: Text(
                  "No logs found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blueGrey[900],
                    child: ListTile(
                      title: Text(
                        logs[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
