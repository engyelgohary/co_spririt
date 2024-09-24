import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/ui/admin/Notifactions/notifictionadmin.dart';
import 'package:bloc/bloc.dart';
import 'package:co_spririt/ui/admin/requests/request_admin.dart';
import 'package:co_spririt/ui/auth/Cubit/login_model_view_cubit.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/od/Notifactions/notifictions_od.dart';
import 'package:co_spririt/ui/od/opportunities/cubit/opportunities_cubit.dart';
import 'package:co_spririt/ui/od/requests/request_collaborator.dart';
import 'package:co_spririt/ui/splash/splashscreen.dart';
import 'package:co_spririt/ui/om/Menu/menu_superadmin.dart';
import 'package:co_spririt/ui/om/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/om/adminforsuperadmin/Cubit/admin_cubit.dart';
import 'package:co_spririt/ui/om/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:co_spririt/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spririt/ui/om/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc_observer_test.dart';
import 'data/dip.dart';

void main() {
  initializeNotification();

  Bloc.observer = MyBlocObserver();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<CollaboratorCubit>(
      create: (context) =>
          CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository()),
    ),
    BlocProvider<AdminCubit>(
      create: (context) => AdminCubit(adminRepository: injectAdminRepository()),
    ),
    BlocProvider<ClientCubit>(
      create: (context) => ClientCubit(clientRepository: injectClientRepository()),
    ),
    BlocProvider<LoginModelViewCubit>(
      create: (context) => LoginModelViewCubit(authRepository: injectAuthRepository()),
    ),
    BlocProvider<OpportunitiesCubit>(
      create: (context) =>
          OpportunitiesCubit(opportunitiesRepository: injectOpportunitiesRepository()),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Splash.routeName,
          routes: {
            Splash.routeName: (context) => Splash(),
            LoginScreen.routeName: (context) => LoginScreen(),
            // Super Admin
            NotificationScreenSuperAdmin.routName: (context) => NotificationScreenSuperAdmin(),
            MenuScreenSuperAdmin.routeName: (context) => MenuScreenSuperAdmin(),
            RequestSuperAdmin.routeName: (context) => RequestSuperAdmin(),
            //   Admin
            NotificationScreenAdmin.routName: (context) => NotificationScreenAdmin(),
            RequestAdmin.routeName: (context) => RequestAdmin(),
            //   Collaborator
            NotificationScreenOD.routName: (context) => NotificationScreenOD(),
            RequestCollaborator.routeName: (context) => RequestCollaborator()
          },
          theme: AppTheme.mainTheme,
        );
      },
    );
  }
}

Future<void> initializeNotification() async {
  final initializationResult = await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
      ],
      debug: true);

  print("Notification initialization result: ${initializationResult}");

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
