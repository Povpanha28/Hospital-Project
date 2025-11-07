import 'dart:convert';
import 'dart:io';

import 'package:HospitalProject/domain/hospital.dart';

class HospitalRepository {
  final String filePath;

  Hospital? _cachedHospital;

  HospitalRepository(this.filePath) {
    // Load into memory on creation so callers can mutate and repository will persist
    try {
      _cachedHospital = readInfo();
    } catch (_) {
      // If readInfo throws, it will have already created a default file in readInfo()
      // so try to load again; if still fails, leave _cachedHospital null and allow
      // callers to create a new Hospital via updateHospital.
      try {
        _cachedHospital = readInfo();
      } catch (e) {
        print('⚠️ Could not initialize in-memory hospital cache: $e');
      }
    }
  }

  /// Read hospital data from the JSON file and convert to object.
  /// If file does not exist, create a default hospital, save it, and return it.
  Hospital readInfo() {
    final file = File(filePath);

    if (!file.existsSync()) {
      // Create parent directory if needed
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      // Return a sensible default hospital and persist it immediately
      final defaultHospital = Hospital(
        name: 'City General Hospital',
        contact: '',
        location: '',
        doctors: [],
        patients: [],
        appointments: [],
      );

      writeInfo(defaultHospital);
      _cachedHospital = defaultHospital;
      return defaultHospital;
    }

    try {
      final content = file.readAsStringSync();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final h = Hospital.fromJson(data);
      _cachedHospital = h;
      return h;
    } catch (e) {
      // If JSON is invalid or other read error occurs, surface the error
      print('✗ Failed to read hospital data from ${file.path}: $e');
      rethrow;
    }
  }

  /// Overwrite entire hospital data to JSON file (atomic from caller perspective).
  void writeInfo(Hospital hospital) {
    final file = File(filePath);
    try {
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(hospital.toJson());

      // Overwrite the file and flush to disk.
      file.writeAsStringSync(jsonString, flush: true);
      print('✓ Wrote hospital data to ${file.path}');
      // update cache after successful write
      _cachedHospital = hospital;
    } catch (e) {
      print('✗ Failed to write hospital data to ${file.path}: $e');
      rethrow;
    }
  }

  /// Append new appointments to the stored file without duplicating by id.
  /// This reads the current file into an object, merges new appointments,
  /// then writes the full hospital object back to disk.
  void appendAppointments(List<Appointment> newAppointments) {
    // Use cached hospital when available to avoid repeated file reads
    final hospital = _cachedHospital ?? readInfo();

    // Build set of existing IDs to avoid duplicates
    final existingIds = hospital.appointments.map((a) => a.id).toSet();

    // Add only appointments whose id is not present
    for (var apt in newAppointments) {
      if (!existingIds.contains(apt.id)) {
        hospital.appointments.add(apt);
        existingIds.add(apt.id);
      }
    }

    // Persist full hospital object
    writeInfo(hospital);
  }

  /// Replace the entire hospital object in storage with a new one.
  void updateHospital(Hospital newHospital) {
    writeInfo(newHospital);
    _cachedHospital = newHospital;
  }

  /// Return the in-memory hospital object (loads from file if needed).
  Hospital get hospital {
    if (_cachedHospital != null) return _cachedHospital!;
    _cachedHospital = readInfo();
    return _cachedHospital!;
  }

  /// Convenience mutators that modify the in-memory object and persist immediately.
  void addDoctor(Doctor doctor) {
    final h = hospital;
    h.doctors.add(doctor);
    writeInfo(h);
  }

  void addPatient(Patient patient) {
    final h = hospital;
    h.patients.add(patient);
    writeInfo(h);
  }

  void addAppointment(Appointment appointment) {
    final h = hospital;
    // avoid duplicates by id
    if (h.appointments.any((a) => a.id == appointment.id)) return;
    h.appointments.add(appointment);
    writeInfo(h);
  }

  void updateAppointment(Appointment appointment) {
    final h = hospital;
    final idx = h.appointments.indexWhere((a) => a.id == appointment.id);
    if (idx != -1) {
      h.appointments[idx] = appointment;
      writeInfo(h);
    } else {
      // if not found, append and save
      h.appointments.add(appointment);
      writeInfo(h);
    }
  }

  void removeAppointmentById(String id) {
    final h = hospital;
    h.appointments.removeWhere((a) => a.id == id);
    writeInfo(h);
  }
}
