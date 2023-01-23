import 'package:youcanpay_sdk/src/validators/card_information_validator.dart';

import '../configs/constants.dart';
import '../models/ycp_response_cashplus.dart';
import '../models/ycp_response_sale.dart';
import '../models/ycpay_response.dart';
import '../services/based_service.dart';
import '../factories/ycp_response_factory.dart';
import '../models/http_response.dart';

class PayWithCashPlusService extends BasedService {
  /// Executes the payment with CashPlus service with a given transaction token.
  Future<void> payWithCashPlus({
    required String token,
    required String pubKey,
    required Function(String? transactionId, String? token) onSuccessfulPayment,
    required Function(String? message) onFailedPayment,
  }) async {
    final Map<String, String> params = {}
      ..token(token)
      ..pubKey(pubKey)
      ..isMobile("1");

    try {
      HttpResponse response = await httpAdapter.post(
        url: Constants.endpoints.payWithCashPlusUrl,
        body: params,
      );
      final YCPayResponse ycPayResponse = YCPResponseFactory.fromJSON(response);

      if (ycPayResponse is YCPResponseCashPlus) {
        onSuccessfulPayment(ycPayResponse.transactionId, ycPayResponse.token);
      } else if (ycPayResponse is YCPResponseSale) {
        onFailedPayment(ycPayResponse.message);
      }
    } catch (e) {
      onFailedPayment(e.toString());
    }
  }
}
