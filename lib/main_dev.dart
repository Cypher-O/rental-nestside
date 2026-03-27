import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/bootstrap.dart';
import 'app/flavors.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.dev');

  FlavorConfig.create(
    flavor: Flavor.dev,
    apiBaseUrl: dotenv.env['API_BASE_URL'] ?? '',
    paystackPublicKey: dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '',
    appName: dotenv.env['APP_NAME'] ?? 'RentEase Dev',
  );

  bootstrap(enableLogging: true);
}
