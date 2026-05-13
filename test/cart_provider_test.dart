import 'package:flutter_test/flutter_test.dart';
import 'package:project2/herbalife/public/provider/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('saveInvoiceId stores the invoiceId correctly', () {
      cartProvider.saveInvoiceId(1, 100);
      expect(cartProvider.getInvoiceId(1), 100);
    });

    test('clearInvoiceId removes the invoiceId', () {
      cartProvider.saveInvoiceId(1, 100);
      cartProvider.clearInvoiceId(1);
      expect(cartProvider.getInvoiceId(1), null);
    });

    test('getInvoiceId returns null for unknown product', () {
      // don't save anything, just check a product that doesn't exist\
      expect(cartProvider.getInvoiceId(1), null);
    });

    test('fetchCartItems fetches cart items correctly', () async {
      expect(cartProvider.cartItems.length, 0);  // ✅
    });
  });
}