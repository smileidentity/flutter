import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smile_id/messages.g.dart';
import 'package:smile_id/smile_id.dart';

@GenerateNiceMocks([MockSpec<SmileIDApi>()])
@GenerateNiceMocks([MockSpec<FlutterAuthenticationRequest>()])
@GenerateNiceMocks([MockSpec<FlutterEnhancedKycRequest>()])
import 'smile_id_test.mocks.dart';


void main() {
  setUp(() {
    final SmileIDApi platformInterface = MockSmileIDApi();
    SmileID.platformInterface = platformInterface;
  });

  test("initialize call is proxied", () {
    SmileID.initialize();
    verify(SmileID.platformInterface.initialize());
  });

  test("authenticate call is proxied", () {
    final FlutterAuthenticationRequest request = MockFlutterAuthenticationRequest();
    SmileID.api.authenticate(request);
    verify(SmileID.platformInterface.authenticate(request));
  });

  test("enhanced kyc async is proxied", () {
    final FlutterEnhancedKycRequest request = MockFlutterEnhancedKycRequest();
    SmileID.api.doEnhancedKycAsync(request);
    verify(SmileID.platformInterface.doEnhancedKycAsync(request));
  });
}
