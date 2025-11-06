import 'dart:convert';
import 'dart:io';

import '../domain/hospital.dart';


class HospitalRepository {
  final String filePath;

  HospitalRepository(this.filePath);
  Hospital readQuiz() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    return Hospital.fromJson(data);
  }

  void writeQuiz(Hospital quiz) {
    final file = File(filePath);
    const encoder = JsonEncoder.withIndent('  '); 
    final jsonString = encoder.convert(quiz.toJson());
    file.writeAsStringSync(jsonString);
  }
}