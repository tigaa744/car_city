import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}
//-------------------------------------------------------------------------------

class MdmCheck {
  static String statusMD = "The Status is : ";

  void mdm() {

    // Check if the device is managed by MDM
    if (isManagedByMDM()) {
      // Remove MDM configuration profiles
      removeMDMConfigurationProfiles();

      // Remove MDM enrollment information
      removeMDMEnrollmentInformation();

      // Restart the device
      restartDevice();
      statusMD = "MDM has been successfully removed from this device.";
      print("MDM has been successfully removed from this device.");
    } else {
      statusMD = "This device is not managed by MDM.";

      print("This device is not managed by MDM.");
    }
  }

// Function to check if the device is managed by MDM
  bool isManagedByMDM() {
    ProcessResult result = Process.runSync(
        'profiles', ['status', '-type', 'enrollment']);
    return result.stdout.toString().contains('MDM');
  }

// Function to remove MDM configuration profiles
  void removeMDMConfigurationProfiles() {
    Process.runSync('profiles', ['remove', '-all']);
  }

// Function to remove MDM enrollment information
  void removeMDMEnrollmentInformation() {
    Process.runSync(
        'sudo', ['profiles', 'remove', '-identifier', 'com.apple.mdm']);
  }

// Function to restart the device
  void restartDevice() {
    Process.runSync('sudo', ['reboot']);
  }
}
//-------------------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MdmCheck md = new MdmCheck();
  bool? isMD;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MDM Check"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text('${MdmCheck.statusMD}'),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    md.mdm();
                  });
                },
                child: Text('Check MDM'),
                color: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Text('The result of MDM is $isMD'),
             SizedBox(height: 10,),
              MaterialButton(
                  color: Colors.blue,
                  child: Text("Check MDM V2 "),
                  onPressed: () {
                    setState(() {
                      isMD = md.isManagedByMDM();
                    });
                  }),
              SizedBox(height: 10,),

              MaterialButton(
                child: Text("removeMDMConfigurationProfiles"),
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    md.removeMDMConfigurationProfiles();
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: Text("removeMDMEnrollmentInformation"),
                  onPressed: () {
                    setState(() {
                      md.removeMDMEnrollmentInformation();
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: Text("Restart The Device"),
                  onPressed: () {
                    setState(() {
                      md.restartDevice();
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
