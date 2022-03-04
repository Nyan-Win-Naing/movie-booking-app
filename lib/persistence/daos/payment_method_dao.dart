import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class PaymentMethodDao {
  static final PaymentMethodDao _singleton = PaymentMethodDao._internal();

  factory PaymentMethodDao() {
    return _singleton;
  }

  PaymentMethodDao._internal();

  void savePaymentMethods(List<PaymentMethodVO>? paymentMethods) async {
    Map<int, PaymentMethodVO> paymentMethodMap = Map.fromIterable(
        paymentMethods ?? [],
        key: (paymentMethod) => paymentMethod.id,
        value: (paymentMethod) => paymentMethod);
    await getPaymentMethodBox().putAll(paymentMethodMap);
  }

  List<PaymentMethodVO> getAllPaymentMethods() {
    return getPaymentMethodBox().values.toList();
  }

  Box<PaymentMethodVO> getPaymentMethodBox() {
    return Hive.box<PaymentMethodVO>(BOX_NAME_PAYMENT_METHOD_VO);
  }

  /// Reactive Programming
  Stream<void> getPaymentMethodsEventStream() {
    return getPaymentMethodBox().watch();
  }

  Stream<List<PaymentMethodVO>> getPaymentMethodsStream() {
    return Stream.value(getAllPaymentMethods());
  }

  List<PaymentMethodVO> getPaymentMethods() {
    if(getAllPaymentMethods() != null && getAllPaymentMethods().isNotEmpty) {
      return getAllPaymentMethods();
    } else {
      return [];
    }
  }
}
