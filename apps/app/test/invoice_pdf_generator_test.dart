import 'package:app/features/account/domain/customer_order.dart';
import 'package:app/features/account/domain/invoice_pdf_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoicePdfGenerator Tests', () {
    test('generates valid PDF document bytes matching BuyNaija order template', () async {
      final order = CustomerOrder(
        id: '1811',
        orderNumber: 'ORD-1793458691802-863YFRV2',
        date: DateTime.parse('2026-10-31T14:58:11.849Z'),
        status: OrderStatus.processing,
        paymentState: 'paid',
        total: 2530000,
        paymentMethod: 'card_or_bank',
        shippingAddress: ShippingAddress(
          fullName: 'Chisom Okeke',
          street: '12 Nexus Road, GRA',
          city: 'Aba',
          state: 'Abia',
          zipCode: '450001',
          phone: '+234 801 234 5678',
        ),
        items: [
          OrderItem(
            id: '306',
            productId: '4',
            productName: 'Demo Product 3 - Black',
            variantName: 'Black / Size 42',
            price: 2530000,
            quantity: 1,
            totalPrice: 2530000,
          ),
        ],
        payments: [
          CustomerOrderPayment(
            id: '1813',
            reference: 'PSK-54fc7825b5f546a2b407860ea7d627c7',
            amount: 2530000,
            currency: 'NGN',
            status: 'success',
            paymentMethod: 'card_or_bank',
          ),
        ],
      );

      final pdfBytes = await InvoicePdfGenerator.generate(order);

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);

      // Verify valid PDF file magic header (%PDF-)
      final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
      expect(header, '%PDF-');
    });

    test('generates PDF for unpaid order with fallback values', () async {
      final order = CustomerOrder(
        id: '1812',
        orderNumber: 'ORD-UNPAID-001',
        date: DateTime.now(),
        status: OrderStatus.unpaid,
        paymentState: 'unpaid',
        total: 1000000,
        paymentMethod: 'Paystack',
        shippingAddress: ShippingAddress(
          fullName: 'Jane Doe',
          street: '',
          city: 'Lagos',
          zipCode: '',
          phone: '',
        ),
        items: [],
      );

      final pdfBytes = await InvoicePdfGenerator.generate(order);

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(100));
      final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
      expect(header, '%PDF-');
    });
  });
}

