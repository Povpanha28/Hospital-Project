import 'dart:io';

enum DoctorSpecialization {
  InternalMedicine,
  Surgery,
  Pediatrics,
  ObstetricsGynecology,
  Psychiatry,
}

class User {
  int? userId;
  String gmail;
  String password;
  bool isLoggedIn;

  User({
    this.userId,
    required this.gmail,
    required this.password,
    this.isLoggedIn = false,
  });

  bool login(String email, String pass) {
    if (gmail == email && password == pass) {
      isLoggedIn = true;
      print("Login successful! Welcome back.");
      return true;
    } else {
      print("Login failed! Invalid email or password.");
      return false;
    }
  }

  bool logout() {
    if (!isLoggedIn) {
      print("You are not logged in.");
      return true;
    }
    isLoggedIn = false;
    print("Logout successful! Goodbye.");
    return false;
  }
}

class Admin extends User {
  Admin({required int userId, required String gmail, required String password})
      : super(userId: userId, gmail: gmail, password: password);
}

class Hospital {
  Admin admin = Admin(userId: 01, gmail: "admin", password: "123");
  String name;
  String location;
  String contact;
  List<Doctor> doctors;
  List<Patient> patients;
  List<Appointment> appointments;

  Hospital({
    required this.name,
    required this.contact,
    required this.location,
    required this.doctors,
    required this.patients,
    required this.appointments,
  });

  void addPatient(Patient patient) {
    // Check if patient already exists
    bool exists = patients.any((p) => p.id == patient.id);
    if (exists) {
      print("Patient with ID ${patient.id} already exists");
      return;
    }
    patients.add(patient);
    print("Patient ${patient.name} added successfully");
  }

  void addDoctor(Doctor doctor) {
    // Check if doctor already exists
    bool exists = doctors.any((d) => d.id == doctor.id);
    if (exists) {
      print("Doctor with ID ${doctor.id} already exists");
      return;
    }
    doctors.add(doctor);
    print("Doctor ${doctor.name} added successfully");
  }

  void addAppointment(Appointment appointment) {
    // Prevent creating appointments in the past
    if (appointment.date.isBefore(DateTime.now())) {
      throw Exception(
          "Cannot create appointment in the past (${appointment.date}).");
    }

    bool exists = appointments.any((a) => a.id == appointment.id);
    if (exists) {
      print("Appoinment with ID ${appointment.id} already exists");
      return;
    }

    appointments.add(appointment);
    print("Appointment ${appointment.id} added successfully");
  }

  Doctor? authenticateDoctor(String email, String password) {
    try {
      Doctor doctor = doctors.firstWhere((d) => d.gmail == email);
      if (doctor.login(email, password)) {
        return doctor;
      }
      return null;
    } catch (e) {
      print("✗ Doctor account not found");
      return null;
    }
  }

  Doctor? findDoctorById(String id) {
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Patient? findPatientById(String id) {
    try {
      return patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void viewAllAppointment() {
    if (appointments.isEmpty) {
      print("No appointments found");
      return;
    }

    for (var a in appointments) {
      print("\nAppointment ID: ${a.id}");
      print("Doctor: ${a.doctor.name} (${a.doctor.id})");
      print("Patient: ${a.patient.name} (${a.patient.id})");
      print("Date: ${a.date}");
      print("Status: ${a.status ? 'Confirmed' : 'Pending'}");
    }
  }

  Patient? getPatientInfo() {
    stdout.write("Enter Patient Name: ");
    String? patientName = stdin.readLineSync();

    stdout.write("Enter Patient Age: ");
    String? ageInput = stdin.readLineSync();
    int? patientAge = int.tryParse(ageInput ?? '');

    stdout.write("Enter Patient Gender: ");
    String? patientGender = stdin.readLineSync();

    if (patientName == null ||
        patientName.isEmpty ||
        patientAge == null ||
        patientGender == null ||
        patientGender.isEmpty) {
      print("❌ Invalid input. Please try again.");
      return null;
    }

    return Patient(age: patientAge, gender: patientGender, name: patientName);
  }

  /// Prompt user for doctor id, patient id and date/time and
  /// return an [Appointment] instance or null if input was invalid.
  Appointment? getAppointmentFromUserInput() {
    stdout.write("Enter Doctor ID: ");
    String? doctorId = stdin.readLineSync();

    stdout.write("Enter Patient ID: ");
    String? patientId = stdin.readLineSync();

    stdout.write(
      "Enter Date and time (YYYY-MM-DD HH:MM) :",
    );
    String? dateInput = stdin.readLineSync();

    if (doctorId == null || doctorId.isEmpty) {
      print("✗ Doctor ID cannot be empty");
      return null;
    }

    if (patientId == null || patientId.isEmpty) {
      print("✗ Patient ID cannot be empty");
      return null;
    }

    final doctor = findDoctorById(doctorId);
    if (doctor == null) {
      print("✗ Doctor with ID $doctorId not found");
      return null;
    }

    final patient = findPatientById(patientId);
    if (patient == null) {
      print("✗ Patient with ID $patientId not found");
      return null;
    }

    DateTime date;
    if (dateInput == null || dateInput.trim().isEmpty) {
      date = DateTime.now();
    } else {
      // Try to parse input like "YYYY-MM-DD HH:MM"
      try {
        // Replace space with 'T' so DateTime.parse can handle it
        String normalized = dateInput.trim().replaceFirst(' ', 'T');
        date = DateTime.parse(normalized);
      } catch (e) {
        // Fallback: try parsing only date portion
        try {
          date = DateTime.parse(dateInput.trim());
        } catch (e) {
          print("✗ Invalid date format. Using current date/time instead.");
          date = DateTime.now();
        }
      }
    }

    return Appointment(date: date, doctor: doctor, patient: patient);
  }

  /// Add the appointment to hospital records and attach it to doctor and patient.
  /// Handles exceptions from [addAppointment] (e.g. past dates).
  void createAndAssignAppointment(Appointment appointment) {
    try {
      addAppointment(appointment);
    } catch (e) {
      print("✗ ${e.toString()}");
      return;
    }

    // Attach to doctor and patient
    appointment.doctor.appointments.add(appointment);
    appointment.patient.appointments.add(appointment);

    print(
      "✓ Appointment ${appointment.id} assigned to Dr. ${appointment.doctor.name} for patient ${appointment.patient.name} on ${appointment.date}",
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'admin': {
          'userId': admin.userId,
          'gmail': admin.gmail,
          'password': admin.password
        },
        'location': location,
        'contact': contact,
        'patients': patients.map((p) => p.toJson()).toList(),
        'doctors': doctors.map((d) => d.toJson()).toList(),
        'appointments': appointments.map((d) => d.toJson()).toList(),
      };

  Hospital.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        admin = (json['admin'] is Map)
            ? Admin(
                userId: (json['admin']['userId'] as int?) ?? 1,
                gmail: (json['admin']['gmail'] as String?) ?? 'admin@gmail.com',
                password: (json['admin']['password'] as String?) ?? '123456',
              )
            : Admin(userId: 1, gmail: 'admin@gmail.com', password: '123456'),
        location = json['location'] ?? '',
        contact = json['contact'] ?? '',
        doctors = [],
        patients = [],
        appointments = [] {
    // Parse patients
    if (json['patients'] is List) {
      for (var p in json['patients']) {
        if (p is Map<String, dynamic>) {
          patients.add(Patient.fromJson(p));
        }
      }
    }

    // Parse doctors
    if (json['doctors'] is List) {
      for (var d in json['doctors']) {
        if (d is Map<String, dynamic>) {
          doctors.add(Doctor.fromJson(d));
        }
      }
    }

    // Build lookup maps
    final docById = {for (var d in doctors) d.id: d};
    final patById = {for (var p in patients) p.id: p};

    // Parse appointments and link to doctor/patient
    if (json['appointments'] is List) {
      for (var a in json['appointments']) {
        if (a is Map<String, dynamic>) {
          String? docId;
          String? patId;

          if (a['doctor'] is String) {
            docId = a['doctor'];
          } else if (a['doctor'] is Map) {
            docId = (a['doctor']['id'] as String?);
          }

          if (a['patient'] is String) {
            patId = a['patient'];
          } else if (a['patient'] is Map) {
            patId = (a['patient']['id'] as String?);
          }

          final doctor = docId != null ? docById[docId] : null;
          final patient = patId != null ? patById[patId] : null;

          if (doctor != null && patient != null) {
            final appt = Appointment.fromJson(
              a,
              doctor: doctor,
              patient: patient,
            );
            appointments.add(appt);
            doctor.appointments.add(appt);
            patient.appointments.add(appt);
          }
        }
      }
    }
  }
}

class Doctor extends User {
  static int _idCounter = 1;
  String id;
  String name;
  DoctorSpecialization specialization;
  String contact;
  List<Appointment> appointments;

  Doctor({
    int? userId,
    required String gmail,
    required String password,
    String? id,
    required this.name,
    required this.contact,
    required this.specialization,
    List<Appointment>? appointments,
  })  : id = id ?? 'D${Doctor._idCounter++}',
        appointments = appointments ?? [],
        super(userId: userId, gmail: gmail, password: password);

  void viewAppoinments() {
    print("\n=== Appointments for Dr. $name ===");
    if (appointments.isEmpty) {
      print("No appointments scheduled");
      return;
    }

    for (var appointment in appointments) {
      print("\nAppointment ID: ${appointment.id}");
      print("Patient: ${appointment.patient.name}");
      print("Date: ${appointment.date}");
      print("Status: ${appointment.status ? 'Confirmed' : 'Pending'}");
      // choose option to accept appointment

      // if (appointment.hasMeeting()) {
      //   print(
      //     "Meeting: ${appointment.meeting!.room} - ${appointment.meeting!.getMeetingStatus()}",
      //   );
      // }
    }
    // Option to accept appointments
  }

  void acceptAppoinment(Appointment appointment) {
    if (!appointments.contains(appointment)) {
      print("This appointment is not assigned to you");
      return;
    }

    if (appointment.status) {
      print("Appointment already accepted");
      return;
    }

    appointment.status = true;
    print(
      "Appointment ${appointment.id} accepted for patient ${appointment.patient.name}",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gmail': gmail,
        'password': password,
        'contact': contact,
        'specialization': specialization.toString().split('.').last,
        'appointments': appointments.map((a) => a.id).toList(),
      };

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // specialization may be stored as string
    DoctorSpecialization spec = DoctorSpecialization.InternalMedicine;
    if (json['specialization'] is String) {
      final s = (json['specialization'] as String).toLowerCase();
      if (s.contains('surgery')) spec = DoctorSpecialization.Surgery;
      if (s.contains('pediatrics')) spec = DoctorSpecialization.Pediatrics;
      if (s.contains('obstetrics') || s.contains('gynecology'))
        spec = DoctorSpecialization.ObstetricsGynecology;
      if (s.contains('psychiatry')) spec = DoctorSpecialization.Psychiatry;
    }

    final id = json['id'] as String?;
    final doctor = Doctor(
      id: id,
      gmail: (json['gmail'] as String?) ?? '',
      password: (json['password'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      contact: (json['contact'] as String?) ?? '',
      specialization: spec,
      appointments: [], // appointments linked later by Hospital.fromJson
    );

    if (id != null) {
      final match = RegExp(r"(\d+)").firstMatch(id);
      if (match != null) {
        final val = int.tryParse(match.group(0) ?? '');
        if (val != null && val >= Doctor._idCounter) {
          Doctor._idCounter = val + 1;
        }
      }
    }

    return doctor;
  }
}

class Patient {
  static int _idCounter = 1;
  String id;
  String name;
  int age;
  String gender;
  List<Appointment> appointments;

  Patient({
    required this.age,
    required this.gender,
    String? id,
    required this.name,
    List<Appointment>? appointments,
  })  : id = id ?? 'P${Patient._idCounter++}',
        appointments = appointments ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'appointments': appointments.map((a) => a.id).toList(),
      };

  factory Patient.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final patient = Patient(
      id: id,
      name: (json['name'] as String?) ?? '',
      age: (json['age'] is int)
          ? json['age'] as int
          : int.tryParse('${json['age']}') ?? 0,
      gender: (json['gender'] as String?) ?? '',
      appointments: [],
    );

    // If an id was provided like 'P3', advance the static counter so new IDs continue from max
    if (id != null) {
      final match = RegExp(r"(\d+)").firstMatch(id);
      if (match != null) {
        final val = int.tryParse(match.group(0) ?? '');
        if (val != null && val >= Patient._idCounter) {
          Patient._idCounter = val + 1;
        }
        
      }
    }

    return patient;
  }
}

class Appointment {
  static int _idCounter = 1;
  String id;
  DateTime date;
  bool status;
  Doctor doctor;
  Patient patient;
  Meeting? meeting;

  Appointment({
    String? id,
    required this.date,
    this.status = false,
    required this.doctor,
    required this.patient,
    this.meeting,
  }) : id = id ?? 'A${Appointment._idCounter++}';

  Meeting? createMeeting(String room) {
    if (!status) {
      print("Cannot create meeting for unconfirmed appointment");
      return null;
    }

    if (meeting != null) {
      print("Meeting already exists for this appointment");
      return null;
    }

    meeting = Meeting(id: "MEET${this.id}", dateTime: date, room: room);

    print("Meeting created successfully!");
    print("Meeting ID: ${meeting!.id}");
    print("Room: $room");
    print("Date & Time: $date");

    return meeting;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'status': status,
        'doctor': doctor.id,
        'patient': patient.id,
        'meeting': meeting?.toJson(),
      };

  factory Appointment.fromJson(
    Map<String, dynamic> json, {
    required Doctor doctor,
    required Patient patient,
  }) {
    DateTime parsedDate;
    if (json['date'] is String) {
      parsedDate = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else if (json['date'] is DateTime) {
      parsedDate = json['date'];
    } else {
      parsedDate = DateTime.now();
    }

    final id = json['id'] as String?;
    final appt = Appointment(
      id: id,
      date: parsedDate,
      status: json['status'] as bool? ?? false,
      doctor: doctor,
      patient: patient,
      meeting: json['meeting'] is Map<String, dynamic>
          ? Meeting.fromJson(json['meeting'])
          : null,
    );

    if (id != null) {
      final match = RegExp(r"(\d+)").firstMatch(id);
      if (match != null) {
        final val = int.tryParse(match.group(0) ?? '');
        if (val != null && val >= Appointment._idCounter) {
          Appointment._idCounter = val + 1;
        }
      }
    }

    return appt;
  }
}

class Meeting {
  String? id;
  DateTime dateTime;
  String room;

  Meeting({this.id, required this.dateTime, required this.room});

  Map<String, dynamic> toJson() => {
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'room': room,
      };

  factory Meeting.fromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now();
    return Meeting(
      id: json['id'] as String?,
      dateTime: dt,
      room: (json['room'] as String?) ?? '',
    );
  }
}
