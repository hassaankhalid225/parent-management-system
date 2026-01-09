import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pms/core/constants/app_strings.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/core/routes/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pms/shared/models/user_model.dart';
import 'package:pms/shared/models/child_model.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/diary/presentation/providers/diary_provider.dart';
import 'features/fees/presentation/providers/fee_provider.dart';
import 'features/events/presentation/providers/events_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'shared/providers/theme_provider.dart';
import 'core/network/api_service.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/diary/data/repositories/diary_repository.dart';
import 'features/fees/data/repositories/fee_repository.dart';
import 'features/events/data/repositories/events_repository.dart';
import 'features/notifications/data/repositories/notification_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChildModelAdapter());
  
  // Open Boxes
  await Hive.openBox('auth_box');
  await Hive.openBox('settings_box');
  await Hive.openBox<ChildModel>('children_box');

  // TODO: Initialize Firebase
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Repositories
        ProxyProvider<ApiService, AuthRepository>(
          update: (_, api, _) => AuthRepository(api),
        ),
        ProxyProvider<ApiService, DashboardRepository>(
          update: (_, api, _) => DashboardRepository(api),
        ),
        ProxyProvider<ApiService, DiaryRepository>(
          update: (_, api, _) => DiaryRepository(api),
        ),
        ProxyProvider<ApiService, FeeRepository>(
          update: (_, api, _) => FeeRepository(api),
        ),
        ProxyProvider<ApiService, EventsRepository>(
          update: (_, api, _) => EventsRepository(api),
        ),
        ProxyProvider<ApiService, NotificationRepository>(
          update: (_, api, _) => NotificationRepository(api),
        ),

        // Providers
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update: (_, repo, auth) => auth!..updateRepo(repo),
        ),
        ChangeNotifierProxyProvider<DashboardRepository, DashboardProvider>(
          create: (context) => DashboardProvider(context.read<DashboardRepository>()),
          update: (_, repo, dash) => dash!..updateRepo(repo),
        ),
        ChangeNotifierProxyProvider<DiaryRepository, DiaryProvider>(
          create: (context) => DiaryProvider(context.read<DiaryRepository>()),
          update: (_, repo, diary) => diary!..updateRepo(repo),
        ),
        ChangeNotifierProxyProvider<FeeRepository, FeeProvider>(
          create: (context) => FeeProvider(context.read<FeeRepository>()),
          update: (_, repo, fee) => fee!..updateRepo(repo),
        ),
        ChangeNotifierProxyProvider<EventsRepository, EventsProvider>(
          create: (context) => EventsProvider(context.read<EventsRepository>()),
          update: (_, repo, events) => events!..updateRepo(repo),
        ),
        ChangeNotifierProxyProvider<NotificationRepository, NotificationProvider>(
          create: (context) => NotificationProvider(context.read<NotificationRepository>()),
          update: (_, repo, notif) => notif!..updateRepo(repo),
        ),
      ],
      builder: (context, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          
          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: context.watch<ThemeProvider>().themeMode,
          
          // Router Configuration
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
