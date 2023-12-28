// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polaris_assignment/core/database/database_setup.dart';
import 'package:polaris_assignment/core/helpers/color_constants.dart';
import 'package:polaris_assignment/core/utils/globals.dart';
import 'package:polaris_assignment/core/utils/routes/route_generator.dart';
import 'package:polaris_assignment/core/utils/routes/route_helper.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/gallery_image.dart';
import 'package:polaris_assignment/view/ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHelper.getInstance();

  Globals.databasePath = (await getApplicationDocumentsDirectory()).path;

  Hive.registerAdapter(FormDataAdapter());
  Hive.registerAdapter(FormDataFieldAdapter());
  Hive.registerAdapter(GalleryImageAdapter());
  await DatabaseSetup.setUpHive(Globals.databasePath);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: RouteHelper.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context),
          child: AnnotatedRegion(
              value: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              ),
              child: FToastBuilder()(context, child)),
        );
      },
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: ColorConstants.primary,
          splashColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          unselectedWidgetColor: const Color(0xFF787878)),
      home: const SplashScreen(),
    );
  }
}
