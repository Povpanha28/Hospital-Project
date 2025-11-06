import 'dart:convert';
import 'dart:io';

import '../domain/hospital.dart';

class HospitalRepository {
  final String filePath;

  HospitalRepository(this.filePath);
  Hospital readInfo() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    return Hospital.fromJson(data);
  }

  void writeInfo(Hospital hospital) {
    final file = File(filePath);
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(hospital.toJson());
    file.writeAsStringSync(jsonString);
  }

  /// ✅ Append only new appointments (without overwriting hospital info)
  void appendAppointments(List<Appointment> newAppointments) {
    final file = File(filePath);
    Map<String, dynamic> data = {};

    // Step 1: Read the existing file
    if (file.existsSync()) {
      final contents = file.readAsStringSync();
      data = jsonDecode(contents);
    } else {
      throw Exception("Hospital data file not found at $filePath");
    }

    // Step 2: Get the existing appointments list
    final List<dynamic> existingAppointments =
        (data['appointments'] ?? []) as List<dynamic>;

    // Step 3: Convert new appointments to JSON
    final List<Map<String, dynamic>> newAppointmentJson =
        newAppointments.map((a) => a.toJson()).toList();

    // Step 4: Append new appointments
    existingAppointments.addAll(newAppointmentJson);

    // Step 5: Update the appointments list in the hospital data
    data['appointments'] = existingAppointments;

    // Step 6: Write back to the file
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(data),
      mode: FileMode.write,
    );
  }
}
