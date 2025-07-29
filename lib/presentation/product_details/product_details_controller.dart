import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app1/domain/entities/product.dart';
import 'package:test_app1/utils/interfaces/x_get_controller.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/failures/failures.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../utils/failure_handler.dart';
import '../../utils/log.dart';

class ProductDetailsController extends XGetxController with GetSingleTickerProviderStateMixin {
  final GetProductDetailsUseCase _getProductDetailsUseCase = Get.find<GetProductDetailsUseCase>();
  
  final RxBool isLoading = false.obs;
  final Rx<ProductDetail?> productDetail = Rx<ProductDetail?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;
  final Rx<FailureType> failureType = FailureType.none.obs;
  final Rx<Product?> product = Rx<Product?>(null);
  
  late TabController tabController;
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void initialize() {
    tabController = TabController(length: 4, vsync: this);
    final args = Get.arguments;
    product.value = args['product'] as Product;
    Log.cyan('ProductDetailsController initialize method called for product ID: ${product.value?.id}');
    fetchProductDetails();
  }
  
  Future<void> fetchProductDetails() async {
    if (product.value?.id == null) {
      hasError.value = true;
      errorMessage.value = 'Product ID not found';
      failureType.value = FailureType.device;
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      failureType.value = FailureType.none;
      update();

      final result = await _getProductDetailsUseCase((product.value?.id ?? 0).toString());
      
      result.fold(
        (failure) {
          hasError.value = true;
          _handleFailure(failure);
          update();
        },
        (response) {
          if (response.status && response.data.productDetail != null) {
            productDetail.value = response.data.productDetail;
            logGreen('Successfully fetched product details for ID: ${product.value?.id}');
            update();
          } else {
            hasError.value = true;
            errorMessage.value = 'Product details not found';
            failureType.value = FailureType.server;
            update();
          }
        },
      );
    } catch (e, stackTrace) {
      hasError.value = true;
      errorMessage.value = 'Unexpected error: $e';
      failureType.value = FailureType.unknown;
      logRed('Unexpected error in fetchProductDetails: $e');
      logRed('Stack Trace: $stackTrace');
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _handleFailure(Failure failure) {
    FailureHandler.logFailure(failure, context: 'ProductDetailsController');
    
    if (failure is NetworkFailure) {
      errorMessage.value = failure.message;
      failureType.value = FailureType.network;
    } else if (failure is DeviceFailure) {
      errorMessage.value = FailureHandler.getUserFriendlyMessage(failure);
      failureType.value = FailureType.device;
    } else if (failure is ServerFailure) {
      errorMessage.value = failure.message;
      failureType.value = FailureType.server;
    } else {
      errorMessage.value = FailureHandler.getUserFriendlyMessage(failure);
      failureType.value = FailureType.unknown;
    }
  }

  void retryFetch() {
    fetchProductDetails();
  }
}

enum FailureType {
  none,
  network,
  device,
  server,
  unknown,
}