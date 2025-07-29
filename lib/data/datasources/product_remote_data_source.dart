import 'package:dio/dio.dart';
import 'dart:io';
import '../../domain/entities/top_products_response.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/failures/failures.dart';
import '../../utils/network/endpoints.dart';
import '../../utils/log.dart';
import '../../utils/failure_handler.dart';

abstract class ProductRemoteDataSource {
  Future<TopProductsResponse> getTopProducts();
  Future<ProductDetailResponse> getProductDetails(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<TopProductsResponse> getTopProducts() async {
    try {
      final response = await dio.get(Endpoints.topProducts);
      
      if (response.statusCode == 200) {
        try {
          return TopProductsResponse.fromJson(response.data);
        } catch (e, stackTrace) {
          Log.red('JSON Parsing Error: $e');
          Log.red('Stack Trace: $stackTrace');
          Log.red('Response Data: ${response.data}');
          throw DeviceFailure.fromJsonParsingError(
            response.data.toString(), 
            e,
          );
        }
      } else {
        throw ServerFailure(
          message: 'Failed to load top products',
          statusCode: response.statusCode,
          responseBody: response.data?.toString(),
        );
      }
    } on DioException catch (e) {
      throw FailureHandler.categorizeException(e);
    } on SocketException catch (e, stackTrace) {
      throw FailureHandler.categorizeException(e, stackTrace);
    } catch (e, stackTrace) {
      Log.red('Unexpected Error: $e');
      Log.red('Stack Trace: $stackTrace');
      throw FailureHandler.categorizeException(e, stackTrace);
    }
  }

  @override
  Future<ProductDetailResponse> getProductDetails(String productId) async {
    try {
      final response = await dio.get(Endpoints.productDetails(productId));
      
      if (response.statusCode == 200) {
        try {
          return ProductDetailResponse.fromJson(response.data);
        } catch (e, stackTrace) {
          Log.red('JSON Parsing Error for Product Details: $e');
          Log.red('Stack Trace: $stackTrace');
          Log.red('Response Data: ${response.data}');
          throw DeviceFailure.fromJsonParsingError(
            response.data.toString(), 
            e,
          );
        }
      } else {
        throw ServerFailure(
          message: 'Failed to load product details',
          statusCode: response.statusCode,
          responseBody: response.data?.toString(),
        );
      }
    } on DioException catch (e) {
      throw FailureHandler.categorizeException(e);
    } on SocketException catch (e, stackTrace) {
      throw FailureHandler.categorizeException(e, stackTrace);
    } catch (e, stackTrace) {
      Log.red('Unexpected Error in Product Details: $e');
      Log.red('Stack Trace: $stackTrace');
      throw FailureHandler.categorizeException(e, stackTrace);
    }
  }
} 