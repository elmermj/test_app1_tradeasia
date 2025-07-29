import 'package:get/get.dart';
import 'package:test_app1/utils/interfaces/x_get_controller.dart';
import '../../domain/entities/product.dart';
import '../../domain/failures/failures.dart';
import '../../domain/usecases/get_top_products_usecase.dart';
import '../../utils/failure_handler.dart';
import '../../utils/log.dart';

enum FailureType {
  none,
  network,
  device,
  server,
  unknown,
}

class HomeController extends XGetxController {
  final GetTopProductsUseCase _getTopProductsUseCase = Get.find<GetTopProductsUseCase>();
  
  final RxBool isLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;
  final Rx<FailureType> failureType = FailureType.none.obs;

  @override
  void initialize() {
    Log.cyan('HomeController initialize method called');
    fetchTopProducts();
  }
  
  Future<void> fetchTopProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      failureType.value = FailureType.none;
      update();

      final result = await _getTopProductsUseCase();
      
      result.fold(
        (failure) {
          hasError.value = true;
          _handleFailure(failure);
          update();
        },
        (response) {
          if (response.status && response.data.topProduct.data.isNotEmpty) {
            failureType.value = FailureType.none;
            products.value = response.data.topProduct.data;
            logGreen('Successfully fetched ${products.length} products');
            update();
          } else {
            hasError.value = true;
            errorMessage.value = 'No products found';
            failureType.value = FailureType.server;
            update();
          }
        },
      );
    } catch (e, stackTrace) {
      hasError.value = true;
      errorMessage.value = 'Unexpected error: $e';
      failureType.value = FailureType.unknown;
      logRed('Unexpected error in fetchTopProducts: $e');
      logRed('Stack Trace: $stackTrace');
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _handleFailure(Failure failure) {
    FailureHandler.logFailure(failure, context: 'Controller');
    
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
    fetchTopProducts();
  }
}
