import 'lib/domain/hospital.dart';
import 'lib/ui/console.dart';

void main() {
  List<Doctor> doctors = [];
  List<Patient> patients = [];
  List<Appointment> appointments = [];

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
