import 'package:HospitalProject/domain/hospital.dart';
import 'package:test/test.dart';

void main() {
  late Hospital hospital;
  late Admin admin;
  late Doctor doctor1;
  late Patient patient1;

  setUp(() {
    admin = Admin(userId: 01, gmail: "admin@gmail.com", password: "123456");
    doctor1 = Doctor(
        gmail: "doctor1@gmail.com",
        password: "ilovedart",
        name: 'doctor1',
        contact: '011234567',
        specialization: DoctorSpecialization.InternalMedicine);
    patient1 = Patient(age: 18, gender: "Male", name: "ronan");
    // hospital.patients.add(patient1);
    hospital = Hospital(
        name: 'KhmerHospital',
        contact: '012988765',
        location: "PhnomPenhTmey",
        doctors: [doctor1],
        patients: [patient1],
        appointments: []);
  });

  test('Admin Authetication Login Success', () {
    bool success = admin.login("admin@gmail.com", "123456");

    expect(success, true);
  });

  test('Admin Authetication Login Fail', () {
    bool success = admin.login("admin@gmail.com", "123456haha");
    expect(success, false);
  });

  test('Doctor Authetication Login Success', () {
    bool success = doctor1.login("doctor1@gmail.com", "ilovedart");
    expect(success, true);
  });

  test('Doctor Authetication Login Fail', () {
    bool success = doctor1.login("doctor1@gmail.com", "iloveflutter");
    expect(success, false);
  });

  test("Book Appointment Successful", () {
    // Initially there should be no appointments
    expect(hospital.appointments.length, equals(0));

    // Create a new appointment
    Appointment appointment = Appointment(
      date: DateTime(2025, 11, 20, 10, 30),
      doctor: doctor1,
      patient: patient1,
    );

    // Add the appointment
    hospital.addAppointment(appointment);

    // Verify it was added successfully
    expect(hospital.appointments.length, equals(1));
    expect(hospital.appointments.first.doctor, equals(doctor1));
    expect(hospital.appointments.first.patient, equals(patient1));
  });

  test("Book Appointment in Past should throw", () {
    expect(hospital.appointments.length, equals(0));

    Appointment appointment = Appointment(
      date: DateTime(2025, 11, 1, 10, 30), // past date
      doctor: doctor1,
      patient: patient1,
    );

    // Expect an exception when adding a past appointment
    expect(() => hospital.addAppointment(appointment), throwsException);

    // Ensure no appointment was added
    expect(hospital.appointments.length, equals(0));
  });

  test("Add Patient Successfully", () {
    // Initially 1 patient in the list
    expect(hospital.patients.length, equals(1));

    // Create new patient
    Patient newPatient = Patient(age: 25, gender: "Female", name: "Jessika");

    // Add patient to hospital
    hospital.patients.add(newPatient);

    // Now there should be 2 patients
    expect(hospital.patients.length, equals(2));

    // Optional: verify data integrity
    expect(hospital.patients.last.name, equals("Jessika"));
    expect(hospital.patients.last.age, equals(25));
    expect(hospital.patients.last.gender, equals("Female"));
  });

  test("Doctor Accept the Appointment : ", () {
    // Create a new appointment
    Appointment newAppointment = Appointment(
      date: DateTime(2025, 11, 20, 10, 30),
      doctor: doctor1,
      patient: patient1,
    );

    // Add and assign appointment
    hospital.createAndAssignAppointment(newAppointment);

    // Doctor accepts the appointment
    doctor1.acceptAppoinment(newAppointment);

    // Assert: verify appointment is now marked as accepted
    expect(newAppointment.status, true);

    // Also check that doctor's appointment list includes it
    expect(doctor1.appointments.contains(newAppointment), isTrue);

    // And hospital should track it as well
    expect(hospital.appointments.contains(newAppointment), isTrue);
  });

  test("Doctor Create Meeting for the appointment : ", () {
    // Act: Create appointment
    Appointment newAppointment = Appointment(
      id: "A102",
      date: DateTime(2025, 11, 20, 10, 30),
      doctor: doctor1,
      patient: patient1,
    );

    hospital.createAndAssignAppointment(newAppointment);
    doctor1.acceptAppoinment(newAppointment);

    // Doctor creates a meeting for this appointment
    Meeting newMeeting = newAppointment.createMeeting("A102")!;

    // Assert: check meeting was created correctly
    expect(newMeeting.room, equals("A102"));
    expect(newAppointment.meeting, isNotNull);
  });
}
