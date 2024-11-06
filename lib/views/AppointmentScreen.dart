import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/controllers/AppointmentController.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/Appointment.dart';
import '../models/Doctor.dart';
import '../providers/DoctorProvider.dart';
import '../widgets/bottom_navigation_bar.dart';

// Define the Event class and event map
class Event {
  final String title;
  final DateTime dateTime;
  const Event(this.title, this.dateTime);

  @override
  String toString() => title;
}
class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentController _appointmentController = AppointmentController();

  @override
  //event variables
  late final ValueNotifier<List<Event>> _selectedEvents; //changes in this list are listened to
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState(){
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    // Fetch patients and appointments only if needed
    Future.microtask(() {
      Provider.of<DoctorProvider>(context, listen: false).fetchPatientsForDoctor();
      Provider.of<DoctorProvider>(context, listen:false).fetchAppointmentsForDoctor();
      //updating selected events after querying events for the doctor
      //_selectedEvents.value = _getEventsForDay(_selectedDay!);
      //_selectedEvents.notifyListeners();
    });
    Provider.of<DoctorProvider>(context, listen: false).addListener(_updateSelectedEvents);

  }

  void _updateSelectedEvents() {
    // Update _selectedEvents based on the new appointments fetched
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    Provider.of<DoctorProvider>(context, listen: false).removeListener(_updateSelectedEvents);
    super.dispose();
  }

  //index for bottom navigation
  int selectedIndex = 2;

  //bottom navigation
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/messages');
        break;
      case 2:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  //returning events for selected day
  List<Event> _getEventsForDay(DateTime day) {
    final doctor = Provider.of<DoctorProvider>(context, listen: false).doctor;
    if(doctor == null)return [];

    //create list based on doctor's appointments
    return doctor.appointments.where((appointment){
      return  appointment.dateTime.year == day.year &&
              appointment.dateTime.month == day.month &&
              appointment.dateTime.day == day.day;
    }).map((appointment) => Event(appointment.patientName, appointment.dateTime)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    final DateTime dayWithTime = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0, 0);
      if (!isSameDay(_selectedDay, selectedDay))
      {
        setState(() {
          _selectedDay = dayWithTime;
          _focusedDay = focusedDay;
        });
        _selectedEvents.value = _getEventsForDay(dayWithTime);
        _selectedEvents.notifyListeners();
      }
  }

  _addNewEvent(Doctor? doctor) {
    //ensure doctor has patients
    if (doctor == null||doctor.patients.isEmpty) return;

    print(doctor?.id);

    TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selected time
    DateTime? selectedDate = _selectedDay;
    String? selectedPatientId; //id of the patient the doctor selects
    String? selectedPatientName = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Appointment'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //dropdownbutton to select a patient
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Patient',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor)
                  ),
                  items: doctor.patients.map((patient){
                    return DropdownMenuItem(value: patient.id,
                    child: Text(patient.name),
                    );
                  }).toList(),
                  onChanged: (value){
                    selectedPatientId = value;
                    selectedPatientName = doctor.patients.firstWhere(
                          (patient) => patient.id == value,
                    ).name; // Find and set the patient name based on ID
                  },
                ),
                SizedBox(height: 20),

                // Date Selector
                GestureDetector(
                  onTap: () async {
                    // Show date picker
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDay ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2034),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDay = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "${_selectedDay?.toLocal()}".split(' ')[0], // Display selected date
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Time Selector
                GestureDetector(
                  onTap: () async {
                    // Show time picker
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,

                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        selectedTime.format(context), // Display selected time
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Add Event button
            TextButton(
              onPressed: () {
                if (selectedPatientId != null && selectedDate != null) {
                  final DateTime eventDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  // Create the new Appointment with the selected patientId
                  _createNewAppointment(
                    doctorId: doctor.id,
                    patientId: selectedPatientId!,
                    dateTime: eventDate,
                    patientName: selectedPatientName!,
                  );

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add Event', style: TextStyle(color: Theme.of(context).primaryColor),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColor),),
            ),
          ],
        );
      },
    );
  }


  void _createNewAppointment({
    required String doctorId,
    required String patientId,
    required DateTime dateTime,
    required String patientName,
}) async {
    final newAppointment = Appointment(
      id:'',
      patientId: patientId,
      doctorId: doctorId,
      dateTime: dateTime,
      patientName: patientName
    );

    try{
      //create the appointment in firestore
      await _appointmentController.createAppointment(newAppointment);

      //add to the logged in doctors appointments
      final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
      doctorProvider.doctor?.appointments.add(newAppointment);
      _selectedEvents.value = _getEventsForDay(_selectedDay!);

      print("appointment added successfully");
      SnackBar(content: Text("Appointment added"),);
    } catch (e) {
      print('Failed to add appointment: $e');
      SnackBar(content: Text("Failed to add appointment"),);
    }
  }

  Widget build(BuildContext context) {
    // Access the logged-in Doctor from DoctorProvider
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctor = doctorProvider.doctor;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped
      ),

      //this code is adapted from https://pub.dev/packages/table_calendar
      //which provided the package used to implement the calendar
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            TableCalendar<Event>(
              firstDay: DateTime.utc(2024, 01, 01),
              lastDay: DateTime.utc(2034, 01, 01),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day){
                return isSameDay(_selectedDay, day);
              },
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Change this to your desired color
                  shape: BoxShape.circle, // Shape of the selected day
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade200, // Color for today's date
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(

              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.green.shade200,
                    fontWeight: FontWeight.bold
                ),
                weekdayStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                )
              ),

            ),
            const SizedBox(height: 10.0),
            Expanded(
              //ValueListenableBuilder allows for rebuilding of specific parts of UI
              //in this case allows the events to be updated
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _){
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index){
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).splashColor,
                          ),
                          child: ListTile(
                            onTap: () => print('${value[index]}'),
                            title: Text('${value[index].title}'), // Event title
                            subtitle: Text(
                              '${value[index].dateTime.hour}:${value[index].dateTime.minute.toString().padLeft(2, '0')}', // Event time
                            ),
                          ),
                        );
                      });
                  }

                )
            )
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewEvent(doctor),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        )
    );
  }
}
