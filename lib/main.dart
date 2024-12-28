import 'package:co_spirit/data/edited_api/user_management_apis.dart';
import 'package:co_spirit/edited_ui/all_users/cubit/user_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'edited_ui/oppy_configurations/cubit/configurations_cubits.dart';
import 'edited_ui/settings/cubit/settings_cubit.dart';
import 'data/edited_api/userprofile_apis.dart';
import 'data/edited_api/oppyconfigurations_apis.dart';
import 'ui/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SettingsCubit
        BlocProvider(
          create: (context) =>
              SettingsCubit(userProfileApis: UserProfileApis()),
        ),
        BlocProvider(
          create: (context) =>
              UserManagementCubit(userManagementApis: UserManagementApis()),
        ),
        BlocProvider(
          create: (context) => CustomersCubit(oppyApis: OppyConfigurationApis()),
        ),
        BlocProvider(
          create: (context) => FeasibilitiesCubit(oppyApis: OppyConfigurationApis()),
        ),
        BlocProvider(
          create: (context) => RisksCubit(oppyApis: OppyConfigurationApis()),
        ),
        BlocProvider(
          create: (context) => SolutionsCubit(oppyApis: OppyConfigurationApis()),
        ),
        BlocProvider(
          create: (context) => TeamsCubit(oppyApis: OppyConfigurationApis()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.mainTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
