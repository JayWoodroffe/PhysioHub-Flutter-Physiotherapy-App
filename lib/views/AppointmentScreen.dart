import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  int selectedIndex = 2;


  //static event data
  //TODO get events from firestore
  final List<Event> kEvents = [
    Event('Event 1', DateTime(2024, 10, 21, 10, 0)),
    Event('Event 2', DateTime(2024, 10, 21, 14, 0)),
    Event('Event 3', DateTime(2024, 10, 22, 12, 0)),
    Event('Event 4', DateTime(2024, 10, 23, 16, 0)),
  ];


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
    return kEvents.where((event) {
      return event.dateTime.year == day.year &&
          event.dateTime.month == day.month &&
          event.dateTime.day == day.day;
    }).toList();
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
      }
  }

  void _addNewEvent() {
    String newEventTitle = '';
    TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selected time

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Appointment'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Event Name Input Field
                TextField(
                  decoration: InputDecoration(

                    labelText: 'Patient Name',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (value) {
                    newEventTitle = value;
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
                if (newEventTitle.isNotEmpty && _selectedDay != null) {
                  final DateTime eventDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  setState(() {
                    kEvents.add(Event(newEventTitle, eventDate));
                    _selectedEvents.value = _getEventsForDay(eventDate);
                  });

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



  Widget build(BuildContext context) {
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
                // No need to call `setState()` here
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
          onPressed: _addNewEvent,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        )
    );
  }
}
