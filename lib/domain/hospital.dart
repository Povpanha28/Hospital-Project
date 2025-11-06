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

  User({this.userId, required this.gmail, required this.password});
}

class Admin extends User {
  Admin({required int userId, required String gmail, required String password})
    : super(userId: userId, gmail: gmail, password: password);
  void EditHospitalInfo(
    Hospital hospital, {
    String? name,
    String? location,
    String? contact,
  }) {
    if (name != null) hospital.name = name;
    if (location != null) hospital.location = location;
    if (contact != null) hospital.contact = contact;
    print("Hospital information updated successfully");
  }
}

class Hospital {
  Admin admin = Admin(userId: 01, gmail: "admin@gmail.com", password: "123456");
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
}

class Doctor extends User {
  String id;
  String name;
  DoctorSpecialization specialization;
  String contact;
  List<Appointment> appointments;

  Doctor({
    required int userId,
    required String gmail,
    required String password,
    required this.id,
    required this.name,
    required this.contact,
    required this.specialization,
    required this.appointments,
  }) : super(userId: userId, gmail: gmail, password: password);

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
      // if (appointment.hasMeeting()) {
      //   print(
      //     "Meeting: ${appointment.meeting!.room} - ${appointment.meeting!.getMeetingStatus()}",
      //   );
      // }
    }
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
}

class Patient {
  String id;
  String name;
  String age;
  String gender;
  List<Appointment> appointments;

  Patient({
    required this.age,
    required this.gender,
    required this.id,
    required this.name,
    required this.appointments,
  });

  void bookAppoinment(Hospital hospital, String doctorId, DateTime date) {
    // Find the doctor
    Doctor? doctor;
    try {
      doctor = hospital.doctors.firstWhere((d) => d.id == doctorId);
    } catch (e) {
      print("Doctor with ID $doctorId not found");
      return;
    }

    // Check if doctor is available on that date
    bool hasConflict = doctor.appointments.any(
      (apt) =>
          apt.date.year == date.year &&
          apt.date.month == date.month &&
          apt.date.day == date.day,
    );

    if (hasConflict) {
      print("Doctor is not available on ${date.toString().split(' ')[0]}");
      return;
    }

    // Create new appointment
    String appointmentId = "APT${hospital.appointments.length + 1}";
    Appointment newAppointment = Appointment(
      id: appointmentId,
      date: date,
      status: false, // Pending by default
      doctor: doctor,
      patient: this,
    );

    // Add to all relevant lists
    appointments.add(newAppointment);
    doctor.appointments.add(newAppointment);
    hospital.appointments.add(newAppointment);

    print("Appointment booked successfully!");
    print("Appointment ID: $appointmentId");
    print(
      "Doctor: ${doctor.name} (${doctor.specialization.toString().split('.').last})",
    );
    print("Date: ${date.toString().split(' ')[0]}");
    print("Status: Pending confirmation");
  }
}

class Appointment {
  String id;
  DateTime date;
  bool status;
  Doctor doctor;
  Patient patient;
  Meeting? meeting;

  Appointment({
    required this.id,
    required this.date,
    required this.status,
    required this.doctor,
    required this.patient,
    this.meeting,
  });

  void createMeeting(String room) {
    if (!status) {
      print("Cannot create meeting for unconfirmed appointment");
      return;
    }

    if (meeting != null) {
      print("Meeting already exists for this appointment");
      return;
    }

    meeting = Meeting(id: "MEET$id", dateTime: date, room: room);

    print("Meeting created successfully!");
    print("Meeting ID: ${meeting!.id}");
    print("Room: $room");
    print("Date & Time: $date");
  }
}

class Meeting {
  String? id;
  DateTime dateTime;
  String room;

  Meeting({this.id, required this.dateTime, required this.room});
}
