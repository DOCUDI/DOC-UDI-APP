import 'package:docudi/doctor_appointment_screen/appointment_success_screen.dart';
import 'package:docudi/doctor_appointment_screen/confirm_appointment_screen.dart';
import 'package:docudi/doctor_appointment_screen/doctor_appointment_screen.dart';
import 'package:docudi/doctor_search_screen/doctor_search_screen.dart';
import 'package:docudi/firebase_options.dart';
import 'package:docudi/homescreen/homescreen.dart.dart';
import 'package:docudi/homescreen/login_screen.dart';
import 'package:docudi/homescreen/sign_up_screen.dart';
import 'package:docudi/homescreen/upload_picture_screen.dart';
import 'package:docudi/previous_appointments_screen/previous_appointment_details_screen.dart';
import 'package:docudi/previous_appointments_screen/previous_appointments_screen.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/provider/user.dart';
import 'package:docudi/splash_screen.dart';
import 'package:docudi/symptoms_screen/symptoms_screen.dart';
import 'package:docudi/upcoming_appointments_screen/camera_screen.dart';
import 'package:docudi/upcoming_appointments_screen/confirmed_appointments_screen.dart';
import 'package:docudi/upcoming_appointments_screen/start_successful_screen.dart';
import 'package:docudi/upcoming_appointments_screen/upcoming_appointments_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => User()), ChangeNotifierProvider(create: (ctx) => DataProvider())],
      child: Consumer<User>(
        builder: (ctx, user, _) {
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
              fontFamily: "Poppins",
              primarySwatch: Colors.blue,
            ),
            home: user.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: user.checkUser(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : SignUpScreen(),
                  ),
            routes: {
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              DoctorSearchScreen.routeName: (ctx) => DoctorSearchScreen(),
              DoctorAppointmentScreen.routeName: (ctx) => DoctorAppointmentScreen(),
              ConfirmAppointmentScreen.routeName: (ctx) => ConfirmAppointmentScreen(),
              AppointmentSuccessScreen.routeName: (ctx) => AppointmentSuccessScreen(),
              UpcomingAppointmentsScreen.routeName: (ctx) => UpcomingAppointmentsScreen(),
              ConfirmedAppointmentScreen.routeName: (ctx) => ConfirmedAppointmentScreen(),
              CameraScreen.routeName: (ctx) => CameraScreen(),
              StartSuccessfulScreen.routeName: (ctx) => StartSuccessfulScreen(),
              PreviousAppointmentsScreen.routeName: (ctx) => PreviousAppointmentsScreen(),
              PreviousAppointmentDetailsScreen.routeName: (ctx) => PreviousAppointmentDetailsScreen(),
              SymptomsScreen.routeName: (ctx) => SymptomsScreen(),
              UploadPictureScreen.routeName: (ctx) => UploadPictureScreen(),
            },
          );
        },
      ),
    );
  }
}
