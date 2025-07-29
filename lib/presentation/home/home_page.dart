import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app1/presentation/product_details/product_details_bindings.dart';
import 'package:test_app1/presentation/product_details/product_details_page.dart';
import 'package:test_app1/utils/interfaces/x_get_view.dart';
import 'package:test_app1/widgets/custom_html.dart';
import 'package:test_app1/widgets/x_scaffold.dart';
import '../../domain/entities/product.dart';
import './home_controller.dart';

class HomePage extends XGetView<HomeController> {
    
  const HomePage({super.key});

    @override
  Widget buildView(BuildContext context) {
    return XScaffold(
      useSafeArea: true,
      gradient: k.blackToMidnightBlue,
      appBar: AppBar(
        title: Text(
          'Welcome to TradeAsia',
          style: k.darkOnWhiteTextL,
        ),
        centerTitle: true,
        backgroundColor: k.vantaBlack,
        surfaceTintColor: k.vantaBlack,
      ),
      bottomNavigationBar: Obx(() {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          offset: controller.failureType.value == FailureType.network 
              ? Offset.zero 
              : const Offset(0, 1), // Slides down (off-screen)
          child: controller.failureType.value == FailureType.network
              ? SafeArea(
                  child: Container(
                    height: 20,
                    color: k.customRed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: k.customWhite, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'There might be an issue with the server connection',
                          style: k.darkOnWhiteTextS,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      }),
      body: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          ),
          child: _buildCurrentState(),
        );
      }),
    );
  }

  Widget _buildCurrentState() {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }
    
    if (controller.hasError.value) {
      return _buildErrorState();
    }
    
    if (controller.products.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildProductList();
  }

  Widget _buildLoadingState() {
    return Container(
      key: const ValueKey('loading'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: k.customWhite,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading products...',
              style: TextStyle(
                color: k.customWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      key: const ValueKey('empty'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: k.customWhite.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                color: k.customWhite,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try refreshing to load products',
              style: TextStyle(
                color: k.customWhite.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      key: const ValueKey('products'),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchTopProducts();
        },
        color: k.customWhite,
        backgroundColor: k.customBlack,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }
  
  Widget _buildErrorState() {
    IconData icon;
    Color iconColor;
    String actionText;
    
    switch (controller.failureType.value) {
      case FailureType.network:
        icon = Icons.wifi_off;
        iconColor = Colors.orange;
        actionText = 'Check Connection & Retry';
        break;
      case FailureType.device:
        icon = Icons.error_outline;
        iconColor = Colors.red;
        actionText = 'Try Again';
        break;
      case FailureType.server:
        icon = Icons.cloud_off;
        iconColor = Colors.red;
        actionText = 'Retry';
        break;
      case FailureType.unknown:
        icon = Icons.help_outline;
        iconColor = Colors.grey;
        actionText = 'Try Again';
        break;
      default:
        icon = Icons.error_outline;
        iconColor = Colors.red;
        actionText = 'Retry';
    }
    
    return Container(
      key: ValueKey('error-${controller.failureType.value}'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: k.darkOnWhiteTextM,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.retryFetch,
                icon: const Icon(Icons.refresh),
                label: Text(
                  actionText,
                  style: k.darkOnWhiteTextS.copyWith(
                    color: k.customBlue,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  iconColor: k.customBlue,
                  backgroundColor: k.customWhite,
                ),
              ),
              if (controller.failureType.value == FailureType.network) ...[
                const SizedBox(height: 16),
                Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: k.darkOnWhiteTextM
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 0,
      color: k.customDarkGrey.withValues(alpha: 0.2),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ProductDetailsPage(),
            binding: ProductDetailsBindings(),
            arguments: {
              'product': product,
            },
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (product.productImage?.isNotEmpty ?? false)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.productImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? '',
                          style: k.darkOnWhiteTextM,
                        ),
                        const SizedBox(height: 4),
                        if (product.casNumber?.isNotEmpty ?? false)
                          Text(
                            'CAS: ${product.casNumber}',
                            style: k.darkOnWhiteTextS,
                          ),
                        if (product.hsCode?.isNotEmpty ?? false)
                          Text(
                            'HS Code: ${product.hsCode}',
                            style: k.darkOnWhiteTextS,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (product.iupacName?.isNotEmpty ?? false) ...[
                const SizedBox(height: 12),
                Text(
                  'IUPAC Name: ${product.iupacName}',
                  style: k.darkOnWhiteTextS,
                ),
              ],
              if (product.formula?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formula:',
                      style: k.darkOnWhiteTextS,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: CustomHtml(
                        text: product.formula ?? '',
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Priority: ${product.priority ?? 0}',
                    style: k.darkOnWhiteTextS,
                  ),
                  Text(
                    'ID: ${product.id ?? 0}',
                    style: k.darkOnWhiteTextS,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}