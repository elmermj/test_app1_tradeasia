import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_top_products_usecase.dart';
import 'domain/usecases/get_product_details_usecase.dart';
import 'utils/network/dio.dart';

void initDependencies() {
  // Initialize GetStorage
  GetStorage.init();

  // Register Dio instance
  Get.lazyPut(() => DioClient.dio, fenix: true);

  // Register Data Sources
  Get.lazyPut<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(Get.find<Dio>()),
    fenix: true,
  );

  // Register Repositories
  Get.lazyPut<ProductRepository>(
    () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
    fenix: true,
  );

  // Register Use Cases
  Get.lazyPut<GetTopProductsUseCase>(
    () => GetTopProductsUseCase(Get.find<ProductRepository>()),
    fenix: true,
  );

  Get.lazyPut<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(Get.find<ProductRepository>()),
    fenix: true,
  );
}
