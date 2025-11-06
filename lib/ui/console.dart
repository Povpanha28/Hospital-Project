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
      _adminMenu(hospital);
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

void _adminMenu(Hospital hospital) {
  while (hospital.admin.isLoggedIn) {
    print("\n--- Admin Menu ---");
    print("1. Book Appointment for patient");
    print("2. View All Appointments");
    print("3. Logout");
    stdout.write("Choose an option: ");
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        Appointment appointment = hospital.getAppointmentFromUserInput()!;
        hospital.createAndAssignAppointment(appointment);
      case '2':
        hospital.viewAllAppointment();
        break;
      case '3':
        hospital.admin.logout();
        break;
      default:
        print("Invalid option.");
    }
  }
}

void _doctorMenu(Doctor doctor) {
  while (doctor.isLoggedIn) {
    print("\n--- Doctor Menu ---");
    print("1. View Appointments");
    print("2. Logout");
    stdout.write("Choose an option: ");
    String? option = stdin.readLineSync();

    switch (option) {
      case '1':
        doctor.viewAppoinments();
        break;
      case '2':
        doctor.logout();
        break;
      default:
        print("Invalid option.");
    }
  }
}
