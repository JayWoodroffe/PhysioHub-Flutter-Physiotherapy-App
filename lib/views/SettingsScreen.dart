import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../providers/DoctorProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedIndex = 3;


  @override
  void initState() {
    super.initState();
  }

  //bottom navigation changes
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

  //method to show the dialog to edit the doctor's name
  void _showEditNameDialogue(BuildContext context, String currentName) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController(
        text: currentName);

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: 'Enter new name',
                labelStyle: TextStyle(color: Theme
                    .of(context)
                    .primaryColor)
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator
                    .of(context)
                    .pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                doctorProvider.updateDoctorName(nameController.text);

                setState(() {});
                Navigator
                    .of(context)
                    .pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Name updated successfully'),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },);
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context); //listening for changes in DoctorProvider
    var _doctor = doctorProvider.doctor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Your profile'),
          backgroundColor: Theme
              .of(context)
              .splashColor),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex, onItemTapped: onItemTapped),
      body: Padding(
        padding: const EdgeInsets.only(top: 55.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: Column(
          children: [
            Center(
                child: Stack(
                  children: [
                    _doctor!.profilePicture != ''
                        ? CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(_doctor.profilePicture),
                      backgroundColor: Colors
                          .transparent,
                    )
                        : CircleAvatar(
                        radius: 70,
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                        child:
                        Icon(Icons.person, size: 80, color: Colors.white)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          // Call the uploadProfilePicture method from DoctorProvider
                          String? result = await context
                              .read<DoctorProvider>()
                              .updateProfilePicture();

                          // Check if the result is null or contains an error message
                          if (result != null && !result.startsWith("Error")) {
                            // Success - Show success message
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Profile picture updated successfully')),
                            );
                          } else {
                            // Failure - Show failure message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(result ??
                                      'Failed to update profile picture')),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme
                              .of(context)
                              .splashColor,
                          child: Icon(
                            Icons.camera_alt,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey),
              title: Text('Name',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
              subtitle: Text(
                _doctor.name,
                style: TextStyle(fontSize: 16),
              ),
              trailing: GestureDetector(
                  onTap: () => _showEditNameDialogue(context, _doctor.name),
                  child: Icon(Icons.edit, color: Theme
                      .of(context)
                      .primaryColor)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.grey),
              title: Text(
                'Phone',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              subtitle: Text(
                _doctor.phoneNumber, // Replace with actual phone number
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
