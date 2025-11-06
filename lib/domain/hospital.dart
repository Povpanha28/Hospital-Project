enum DoctorSpecialization {
  InternalMedicine,
  Surgery,
  Pediatrics,
  ObstetricsGynecology,
  Psychiatry,
}

class User {
  int ?userId;
  String gmail;
  String password;

  User({this.userId, required this.gmail, required this.password});
}

class Admin extends User {
  Admin({required int userId, required String gmail, required String password})
    : super(userId: userId, gmail: gmail, password: password);
}

class Hospital {
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
}

class Appointment {
  String id;
  DateTime date;
  bool status;
  Doctor doctor;
  Patient patient;

  Appointment({
    required this.id,
    required this.date,
    required this.status,
    required this.doctor,
    required this.patient,
  });
}

class Meeting {
  String ?id;
  DateTime dateTime;
  String room;

  Meeting({this.id, required this.dateTime, required this.room});
}
