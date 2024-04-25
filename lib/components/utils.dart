import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

//lastUpdateLocalFile() // Get metadata of the local file

String appDatabaseName = 'BengaliDictionary.json';

Future<String> lastUpdatedLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$appDatabaseName');
  final localFileStat = await file.stat();
  DateTime localUpdatedDateTime = localFileStat.modified;
  String updatedAt = localUpdatedDateTime.toString();
  return updatedAt;
}

Future<String> lastUpdatedOnlineFile() async {
  const owner = 'rajibdpi';
  const repo = 'dictionary';
  const filePath = 'assets/BengaliDictionary.json';

  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/$owner/$repo/contents/$filePath'));

  print('API Response Headers: ${response.headers['last-modified']}');

  print('API Response: ${response.statusCode}');
  print('API Response Body: ${response.body}');

  if (response.statusCode == 200 &&
      response.headers.containsKey('last_modified')) {
    // final Map<String, dynamic>? fileInfo = jsonDecode(response.body);
    // final Map<String, dynamic>? headerInfo = jsonDecode(response.body);
    if (response.headers.containsKey('last-modified')) {
      final hDateTime = response.headers['last-modified'];
      // Convert lastModifiedStr to DateTime
      return hDateTime.toString();
    } else {
      // print('Error: Missing or invalid file information.');
      return 'Error: Missing or invalid file information: ${response.statusCode}';
    }
  } else {
    // Handle HTTP error
    // print('Failed to fetch file information: ${response.statusCode}');
    return 'Failed to fetch file information: ${response.statusCode}';
  }
}
