import 'dart:io';
import '../domain/hospital.dart';

class HospitalConsole {
  Hospital hospital;

  HospitalConsole(this.hospital);

  void showConsole() {
    print("Welcome to the Hospital System!");
    print("===============================");
    print("1. Login as Admin");
    print("2. Login as Doctor");
    stdout.write("Choose an option (1 or 2): ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _loginAsAdmin();
        break;
      case '2':
        _loginAsDoctor();
        break;
      default:
        print("Invalid choice. Please restart and choose 1 or 2.");
    }
  }

  void _loginAsAdmin() {
    print("\n--- Admin Login ---");
    stdout.write('Gmail: ');
    String? gmailInput = stdin.readLineSync();

    stdout.write('Password: ');
    String? passwordInput = stdin.readLineSync();

    if (gmailInput != null && passwordInput != null) {
      hospital.admin.login(gmailInput, passwordInput);
    }
  }

  void _loginAsDoctor() {
    print("\n--- Doctor Login ---");
    stdout.write('Gmail: ');
    String? gmailInput = stdin.readLineSync();

    stdout.write('Password: ');
    String? passwordInput = stdin.readLineSync();

    if (gmailInput != null && passwordInput != null) {
      var doctor = hospital.authenticateDoctor(gmailInput, passwordInput);
      if (doctor != null) {
        print("Doctor ${doctor.name} logged in successfully!");
        _doctorMenu(doctor);
      } else {
        print("Invalid doctor credentials.");
      }
    }
  }
}

void _doctorMenu(Doctor doctor) {
  while (doctor.isLoggedIn) {
    print("\n--- Doctor Menu ---");
    print("1. View Appointments");
    print("2. Accept/Reject Appointment");
    print("3. Logout");
    stdout.write("Choose an option: ");
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        doctor.viewAppoinments();
        break;
      
      case '2':
        _manageAppointments(doctor);
        break;
      
      case '3':
        doctor.logout();
        break;
      
      default:
        print("Invalid option.");
    }
  }
}

void _manageAppointments(Doctor doctor) {
  print("\n--- Manage Appointments ---");
  
  List<Appointment> pendingAppointments = 
      doctor.appointments.where((apt) => !apt.status).toList();
  
  if (pendingAppointments.isEmpty) {
    print("No pending appointments.");
    return;
  }

  print("\nPending Appointments:");
  for (var apt in pendingAppointments) {
    print("\nID: ${apt.id}");
    print("Patient: ${apt.patient.name}");
    print("Date: ${apt.date.toString().split(' ')[0]}");
  }

  stdout.write("\nEnter Appointment ID: ");
  String? appointmentId = stdin.readLineSync();
  
  if (appointmentId == null || appointmentId.isEmpty) {
    print("Cancelled.");
    return;
  }

  Appointment? selectedAppointment;
  try {
    selectedAppointment = doctor.appointments.firstWhere(
      (apt) => apt.id == appointmentId
    );
  } catch (e) {
    print("Appointment not found.");
    return;
  }

  print("\n1. Accept");
  print("2. Reject");
  stdout.write("Choose action: ");
  String? action = stdin.readLineSync();

  if (action == '1') {
    doctor.acceptAppoinment(selectedAppointment);
    
    stdout.write("\nCreate meeting? (y/n): ");
    String? createMeeting = stdin.readLineSync();
    
    if (createMeeting?.toLowerCase() == 'y') {
      stdout.write("Enter room: ");
      String? room = stdin.readLineSync();
      if (room != null && room.isNotEmpty) {
        selectedAppointment.createMeeting(room);
      }
    }
  } else if (action == '2') {
    // You can add a reject method later
    print("Reject functionality coming soon.");
  }
}
