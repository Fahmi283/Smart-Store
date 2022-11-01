import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../provider/theme_provider.dart';
import '../screen/login_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: [
          Card(child: Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return ListTile(
                title: const Text('Dark Mode'),
                trailing: ToggleSwitch(
                  minWidth: 60.0,
                  minHeight: 30,
                  initialLabelIndex: (value.isdark) ? 0 : 1,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['OFF', 'ON'],
                  activeBgColors: [
                    [Colors.blue.shade200],
                    [Colors.blue.shade200]
                  ],
                  onToggle: (index) {
                    setState(() {
                      value.changeTheme();
                    });
                  },
                ),
              );
            },
          )),
          Card(
            child: ListTile(
              onTap: () async {
                SmartDialog.showLoading();
                await FirebaseAuth.instance.signOut();
                SmartDialog.dismiss();
                if (mounted) {}
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false);
              },
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
    );
  }
}
