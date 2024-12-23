import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'edited_ui/settings/cubit/settings_cubit.dart';
import 'data/edited_api/userprofile_apis.dart';
import 'data/edited_api/oppyconfigurations_apis.dart';
import 'edited_ui/forms/oppy_configurations/configurations_cubit.dart';
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
        BlocProvider(
          create: (context) => SettingsCubit(userProfileApis: UserProfileApis()),
        ),
        BlocProvider(
          create: (context) => ConfigurationsCubit(
              oppyConfigurationApis: OppyConfigurationApis()),
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
