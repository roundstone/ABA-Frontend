import 'package:flutter/material.dart';
import 'merchant_step_business.dart';
import 'merchant_step_certifications.dart';
import 'merchant_step_identity.dart';
import 'merchant_step_location.dart';
import 'merchant_step_products.dart';

/// Helper widget to render the active onboarding step based on currentStep.
class MerchantOnboardingStepBuilder extends StatelessWidget {
  const MerchantOnboardingStepBuilder({
    super.key,
    required this.currentStep,
    required this.businessName,
    required this.businessType,
    required this.rcNumber,
    required this.isProvisional,
    required this.cacUploaded,
    required this.onProvisionalChanged,
    required this.onUploadCac,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.ninNumber,
    required this.idType,
    required this.idUploaded,
    required this.onIdTypeChanged,
    required this.onUploadId,
    required this.address,
    required this.city,
    required this.state,
    required this.marketCluster,
    required this.bankName,
    required this.accountNumber,
    required this.onClusterChanged,
    required this.products,
    required this.capacity,
    required this.samplePhotosCount,
    required this.onAddPhoto,
    required this.certType,
    required this.certNumber,
    required this.certUploaded,
    required this.confirmSupply,
    required this.agreeToFulfillmentSla,
    required this.onCertTypeChanged,
    required this.onUploadCert,
    required this.onToggleSupplyCapacity,
    required this.onToggleFulfillmentSla,
  });

  final int currentStep;
  final TextEditingController businessName;
  final TextEditingController businessType;
  final TextEditingController rcNumber;
  final bool isProvisional;
  final bool cacUploaded;
  final ValueChanged<bool> onProvisionalChanged;
  final VoidCallback onUploadCac;
  final TextEditingController ownerName;
  final TextEditingController phone;
  final TextEditingController email;
  final TextEditingController ninNumber;
  final String idType;
  final bool idUploaded;
  final ValueChanged<String> onIdTypeChanged;
  final VoidCallback onUploadId;
  final TextEditingController address;
  final TextEditingController city;
  final TextEditingController state;
  final String marketCluster;
  final TextEditingController bankName;
  final TextEditingController accountNumber;
  final ValueChanged<String> onClusterChanged;
  final TextEditingController products;
  final TextEditingController capacity;
  final int samplePhotosCount;
  final VoidCallback onAddPhoto;
  final String certType;
  final TextEditingController certNumber;
  final bool certUploaded;
  final bool confirmSupply;
  final bool agreeToFulfillmentSla;
  final ValueChanged<String> onCertTypeChanged;
  final VoidCallback onUploadCert;
  final ValueChanged<bool?> onToggleSupplyCapacity;
  final ValueChanged<bool?> onToggleFulfillmentSla;

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return MerchantStepBusiness(
          nameController: businessName,
          typeController: businessType,
          rcController: rcNumber,
          isProvisional: isProvisional,
          cacUploaded: cacUploaded,
          onProvisionalChanged: onProvisionalChanged,
          onUploadCac: onUploadCac,
        );
      case 1:
        return MerchantStepIdentity(
          ownerController: ownerName,
          phoneController: phone,
          emailController: email,
          ninController: ninNumber,
          idType: idType,
          idUploaded: idUploaded,
          onIdTypeChanged: onIdTypeChanged,
          onUploadId: onUploadId,
        );
      case 2:
        return MerchantStepLocation(
          addressController: address,
          cityController: city,
          stateController: state,
          marketCluster: marketCluster,
          bankController: bankName,
          accountController: accountNumber,
          onClusterChanged: onClusterChanged,
        );
      case 3:
        return MerchantStepProducts(
          productController: products,
          capacityController: capacity,
          samplePhotosCount: samplePhotosCount,
          onAddPhoto: onAddPhoto,
        );
      default:
        return MerchantStepCertifications(
          certificationType: certType,
          certNumberController: certNumber,
          certUploaded: certUploaded,
          confirmSupplyCapacity: confirmSupply,
          agreeToFulfillmentSla: agreeToFulfillmentSla,
          onCertTypeChanged: onCertTypeChanged,
          onUploadCert: onUploadCert,
          onToggleSupplyCapacity: onToggleSupplyCapacity,
          onToggleFulfillmentSla: onToggleFulfillmentSla,
        );
    }
  }
}
