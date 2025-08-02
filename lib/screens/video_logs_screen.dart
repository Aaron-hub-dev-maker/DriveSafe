import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart'; // For invoking platform methods

class VideoLogsScreen extends StatefulWidget {
  const VideoLogsScreen({super.key});

  @override
  _VideoLogsScreenState createState() => _VideoLogsScreenState();
}

class _VideoLogsScreenState extends State<VideoLogsScreen> {
  List<String> videoLogs = [];
  VideoPlayerController? _controller;
  bool isLoading = true;
  final String apiUrl =
      'http://172.30.103.226:5000/api/video_logs'; // Change this if needed

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    fetchVideoLogs();
  }

  // ✅ Fetch Video Logs from the Backend
  Future<void> fetchVideoLogs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          videoLogs = List<String>.from(data['videos']);
          isLoading = false;
        });
      } else {
        print("Error: Failed to load video logs");
      }
    } catch (e) {
      print("Error fetching video logs: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ✅ Download Video from Server
  Future<void> downloadVideo(String fileName) async {
    try {
      var status = await Permission.videos.request();
      if (!status.isGranted) {
        print("❌ Permission denied");
        return;
      }

      // ✅ Get External Storage Directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory(); // Get storage dir
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String filePath = '${directory!.path}/$fileName';
      final File file = File(filePath);

      // ✅ Download Video
      final response = await http.get(Uri.parse("$apiUrl/$fileName"));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        print("✅ Downloaded to: $filePath");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Saved in: $filePath")));

        refreshGallery(filePath); // Ensure it appears in gallery
      } else {
        print("❌ Error: Video download failed");
      }
    } catch (e) {
      print("❌ Download error: $e");
    }
  }

  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.videos.isGranted) {
        print("✅ Video access permission already granted");
        return;
      }

      var status = await Permission.videos.request();

      if (status.isGranted) {
        print("✅ Video access permission granted");
      } else {
        print("❌ Video access permission denied");
        openAppSettings(); // Redirect to settings if denied
      }
    }
  }

  // ✅ Refresh the Gallery so the file appears instantly
  void refreshGallery(String filePath) async {
    try {
      await MethodChannel(
        'com.example.cc_pro/gallery',
      ).invokeMethod('scanFile', {"path": filePath});
      print("Gallery refreshed: $filePath");
    } catch (e) {
      print("Error refreshing gallery: $e");
    }
  }

  // ✅ Play Video Preview
  void playVideo(String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    String filePath = '${directory!.path}/$fileName';
    File file = File(filePath);

    if (await file.exists()) {
      print("📂 Playing local video: $filePath");
      _controller = VideoPlayerController.file(file);
    } else {
      print("🌐 Streaming from server: $apiUrl/$fileName");
      _controller = VideoPlayerController.networkUrl(
        Uri.parse("$apiUrl/$fileName"),
      );
    }

    _controller!
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
          "VIDEO LOGS",
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
              : videoLogs.isEmpty
              ? const Center(
                child: Text(
                  "No video logs found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: videoLogs.length,
                itemBuilder: (context, index) {
                  String fileName = videoLogs[index];
                  return Card(
                    color: Colors.blueGrey[900],
                    child: ListTile(
                      title: Text(
                        fileName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () => downloadVideo(fileName),
                      ),
                      onTap: () => playVideo(fileName),
                    ),
                  );
                },
              ),
    );
  }
}
