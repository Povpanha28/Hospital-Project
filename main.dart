import 'package:HospitalProject/data/data.provider.dart';
import 'package:HospitalProject/domain/hospital.dart';
import 'package:HospitalProject/ui/console.dart';

void main() {
  // List<Appointment> appointments = [];

  // List<Doctor> doctors = [
  //   Doctor(
  //     gmail: "nha@gmail.com",
  //     password: "123",
  //     name: "nha",
  //     contact: "0112345678",
  //     specialization: DoctorSpecialization.Surgery,
  //     appointments: [],
  //   ),
  //   Doctor(
  //     gmail: "thyrak@gmail.com",
  //     password: "123",
  //     name: "thyrak",
  //     contact: "0112345678",
  //     specialization: DoctorSpecialization.Surgery,
  //     appointments: [],
  //   ),
  //   Doctor(
  //     gmail: "youdy@gmail.com",
  //     password: "123",
  //     name: "youdy",
  //     contact: "0112345678",
  //     specialization: DoctorSpecialization.Surgery,
  //     appointments: [],
  //   ),
  // ];
  // List<Patient> patients = [
  //   Patient(age: 18, gender: "Male", name: "youdy"),
  //   Patient(age: 20, gender: "Female", name: "Sreyka"),
  // ];

  // Hospital hospital = Hospital(
  //     name: "KhmerHospital",
  //     contact: "01234567",
  //     location: "PhnomPenh",
  //     doctors: doctors,
  //     patients: patients,
  //     appointments: appointments);

  HospitalRepository repo = HospitalRepository("./lib/data/hospital.data.json");
  Hospital hospital = repo.readInfo();
  HospitalConsole console = HospitalConsole(hospital);
  // HospitalRepository repo = HospitalRepository("./lib/data/hospital.data.json");

  console.showConsole();
  repo.appendAppointments(hospital.appointments);
}
