import 'lib/domain/hospital.dart';
import 'lib/ui/console.dart';

void main() {
  List<Appointment> appointments = [];

  List<Doctor> doctors = [
    Doctor(
      gmail: "nha@gmail.com",
      password: "123",
      id: "D1",
      name: "nha",
      contact: "0112345678",
      specialization: DoctorSpecialization.Surgery,
      appointments: [],
    ),
  ];
  List<Patient> patients = [];

  Hospital hospital = Hospital(
    name: "Khmer Treatment",
    contact: "0123456789",
    location: "PhnomPenh",
    doctors: doctors,
    patients: patients,
    appointments: appointments,
  );
  HospitalConsole console = HospitalConsole(hospital);

  console.showConsole();
}
