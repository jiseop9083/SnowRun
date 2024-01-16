import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API의 URL. 실제 URL로 대체해야 합니다.
const String apiUrl = "http://172.10.7.69";

