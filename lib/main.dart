import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/bootstrap.dart';
import 'app/flavors.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  FlavorConfig.create(
    flavor: Flavor.production,
    apiBaseUrl: dotenv.env['API_BASE_URL'] ?? '',
    paystackPublicKey: dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '',
    appName: dotenv.env['APP_NAME'] ?? 'RentEase',
  );

  bootstrap(enableLogging: false);
}
