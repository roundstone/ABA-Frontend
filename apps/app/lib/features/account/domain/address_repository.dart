import '../../../core/network/list_query_params.dart';
import 'address_entities.dart';

abstract class AddressRepository {
  Future<List<DeliveryAddress>> getAddresses({ListQueryParams? params});
  Future<DeliveryAddress> createAddress(DeliveryAddress address);
  Future<void> deleteAddress(String id);
  Future<DeliveryAddress> updateAddress(String id, DeliveryAddress address);
}