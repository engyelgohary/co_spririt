import 'package:co_spririt/ui/admin/Menu/menu_admin.dart';
import 'package:co_spririt/ui/admin/Notifactions/notifictionadmin.dart';
import 'package:bloc/bloc.dart';
import 'package:co_spririt/ui/admin/requests/request_admin.dart';
import 'package:co_spririt/ui/auth/Cubit/login_model_view_cubit.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/collaborator/Menu/menu_collaborator.dart';
import 'package:co_spririt/ui/collaborator/Notifactions/notifictions_collaborator.dart';
import 'package:co_spririt/ui/collaborator/opportunities/cubit/opportunities_cubit.dart';
import 'package:co_spririt/ui/collaborator/requests/request_collaborator.dart';
import 'package:co_spririt/ui/splash/splashscreen.dart';
import 'package:co_spririt/ui/superadmin/Menu/menu_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/superadmin/adminforsuperadmin/Cubit/admin_cubit.dart';
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spririt/ui/superadmin/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc_observer_test.dart';
import 'data/dip.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MultiBlocProvider(
          providers: [
            BlocProvider<CollaboratorCubit>(create: (context) => CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository()),),
            BlocProvider<AdminCubit>(create: (context) => AdminCubit(adminRepository: injectAdminRepository()),),
            BlocProvider<ClientCubit>(create: (context) => ClientCubit(clientRepository: injectClientRepository()),),
            BlocProvider<LoginModelViewCubit>(create: (context) => LoginModelViewCubit(authRepository: injectAuthRepository()),),
            BlocProvider<OpportunitiesCubit>(create: (context) => OpportunitiesCubit(opportunitiesRepository: injectOpportunitiesRepository()),)
          ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Splash.routeName,
          routes: {
            Splash.routeName:(context) =>Splash(),
            LoginScreen.routeName: (context) => LoginScreen(),
            // Super Admin
            NotifactionScreenSuperAdmin.routName: (context) => NotifactionScreenSuperAdmin(),
            MenuScreenSuperAdmin.routeName:(context) => MenuScreenSuperAdmin(),
            RequestSuperAdmin.routeName:(context) =>RequestSuperAdmin(),
          //   Admin
            NotifactionScreenAdmin.routName:(context) => NotifactionScreenAdmin(),
            RequestAdmin.routeName:(context) => RequestAdmin(),
          //   Collaborator
            NotifactionScreenCollaborator.routName:(context) => NotifactionScreenCollaborator(),
            RequestCollaborator.routeName:(context) => RequestCollaborator()
          },
          theme: AppTheme.mainTheme,
        );
      },
    );

  }
}


