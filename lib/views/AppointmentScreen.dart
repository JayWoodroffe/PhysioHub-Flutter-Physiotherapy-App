import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/bottom_navigation_bar.dart';

// Define the Event class and event map
class Event {
  final String title;
  const Event(this.title);

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
  final Map<DateTime, List<Event>> kEvents = {
    DateTime(2024, 10, 21, 0, 0, 0): [Event('Event 1'), Event('Event 2')],
    DateTime(2024, 10, 22, 0, 0, 0): [Event('Event 3')],
    DateTime(2024, 10, 23, 0, 0, 0): [Event('Event 4')],
    // Add more events here
  };


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
    final DateTime dayWithTime = DateTime(day.year, day.month, day.day, 0, 0, 0);
    return kEvents[dayWithTime] ?? [];
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
                            title: Text('${value[index]}'),
                          ),
                        );
                      });
                  }

                )
            )
          ],
        ),
      ),
    );
  }
}
