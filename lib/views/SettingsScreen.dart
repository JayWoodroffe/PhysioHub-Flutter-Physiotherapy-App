

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

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).splashColor
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        // Call the uploadProfilePicture method from DoctorProvider
                        String? result = await context.read<DoctorProvider>().updateProfilePicture();

                        // Check if the result is null or contains an error message
                        if (result != null && !result.startsWith("Error")) {
                          // Success - Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile picture updated successfully')),
                          );
                        } else {
                          // Failure - Show failure message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result ?? 'Failed to update profile picture')),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Theme.of(context).splashColor,
                        child: Icon(
                          Icons.camera_alt,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey),
              title: Text(
                'Name',
                style: TextStyle(color: Colors.grey, fontSize: 12,)
              ),
              subtitle: Text('Justin Keep', style: TextStyle(fontSize: 16),),
              trailing: Icon(Icons.edit, color: Theme.of(context).primaryColor),
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
                '+123 456 7890', // Replace with actual phone number
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
            ),
      ),);
  }
}
