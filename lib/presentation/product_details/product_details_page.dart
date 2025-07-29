import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app1/presentation/product_details/product_details_bindings.dart';
import 'package:test_app1/utils/interfaces/x_get_view.dart';
import 'package:test_app1/widgets/custom_html.dart';
import 'package:test_app1/widgets/x_scaffold.dart';
import '../../domain/entities/product_detail.dart';
import './product_details_controller.dart';

class ProductDetailsPage extends XGetView<ProductDetailsController> {
    
  const ProductDetailsPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    return XScaffold(
      useSafeArea: true,
      gradient: k.blackToMidnightBlue,
      horizontalPadding: 0,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.productDetail.value?.productName ?? 'Product Details',
          style: k.darkOnWhiteTextL,
        )),
        centerTitle: true,
        backgroundColor: k.vantaBlack,
        surfaceTintColor: k.vantaBlack,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: k.customWhite),
          onPressed: () => Get.back(),
        ),
      ),
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
    
    if (controller.productDetail.value == null) {
      return _buildEmptyState();
    }
    
    return _buildProductDetails();
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
              'Loading product details...',
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
              'Product not found',
              style: TextStyle(
                color: k.customWhite,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested product could not be found',
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

  Widget _buildProductDetails() {
    final product = controller.productDetail.value!;
    
    return Container(
      key: const ValueKey('product-details'),
      child: Column(
        children: [
          // Product Header
          _buildProductHeader(product),

          // TabBar
          TabBar(
            controller: controller.tabController,
            indicatorColor: k.customLightBlue,
            indicatorWeight: 2,
            labelColor: k.customLightBlue,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            unselectedLabelColor: k.customWhite,
            labelStyle: k.darkOnWhiteTextM,
            unselectedLabelStyle: k.darkOnWhiteTextS,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Applications'),
              Tab(text: 'Industries'),
              Tab(text: 'Related'),
            ],
          ),
          
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildOverviewTab(product),
                _buildApplicationsTab(product),
                _buildIndustriesTab(product),
                _buildRelatedProductsTab(product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader(ProductDetail product) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image and Basic Info
          Row(
            children: [
              if (product.productImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.productImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
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
                      product.productName,
                      style: k.darkOnWhiteTextL.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (product.iupacName.isNotEmpty)
                      Text(
                        'IUPAC: ${product.iupacName}',
                        style: k.darkOnWhiteTextS,
                      ),
                    if (product.casNumber.isNotEmpty)
                      Text(
                        'CAS: ${product.casNumber}',
                        style: k.darkOnWhiteTextS,
                      ),
                    if (product.hsCode.isNotEmpty)
                      Text(
                        'HS Code: ${product.hsCode}',
                        style: k.darkOnWhiteTextS,
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          // Formula
          if (product.formula.isNotEmpty) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formula:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: k.customWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: k.customWhite.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: k.customWhite.withValues(alpha: 0.2)),
                  ),
                  child: CustomHtml(
                    text: product.formula,
                    bodyColor: k.customWhite,
                    pColor: k.customWhite,
                    subColor: k.customWhite,
                    supColor: k.customWhite,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ProductDetail product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information
          _buildSection(
            'Basic Information',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.basicInfo.phyAppearName.isNotEmpty)
                  _buildInfoRow('Physical Appearance', product.basicInfo.phyAppearName),
                if (product.basicInfo.packagingName.isNotEmpty)
                  _buildInfoRow('Packaging', product.basicInfo.packagingName),
                if (product.basicInfo.commonNames.isNotEmpty)
                  _buildInfoRow('Common Names', product.basicInfo.commonNames),
                if (product.categoryName.isNotEmpty)
                  _buildInfoRow('Category', product.categoryName),
                if (product.prodindName.isNotEmpty)
                  _buildInfoRow('Industry', product.prodindName),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Description
          if (product.description.isNotEmpty)
            _buildSection(
              'Description',
              CustomHtml(
                text: product.description,
                bodyColor: k.customWhite,
                pColor: k.customWhite,
                subColor: k.customWhite,
                supColor: k.customWhite,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab(ProductDetail product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: product.application.isNotEmpty
          ? CustomHtml(
            text: product.application,
            bodyColor: k.customWhite,
            pColor: k.customWhite,
            subColor: k.customWhite,
            supColor: k.customWhite,
          )
          : _buildEmptyTab(
              title: 'No application information available',
            ),
    );
  }

  Widget _buildIndustriesTab(ProductDetail product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: product.productIndustries.isNotEmpty
    ? Column(
        children: product.productIndustries.map((industry) {
          return Card(
            color: k.customBlack.withValues(alpha: 0.5),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    industry.prodindName,
                    style: k.darkOnWhiteTextL.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (industry.prodindDesc.isNotEmpty)
                    CustomHtml(
                      text: industry.prodindDesc,
                      bodyColor: k.customWhite,
                      pColor: k.customWhite,
                      subColor: k.customWhite,
                      supColor: k.customWhite,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      )
    : _buildEmptyTab(
        title: 'No industry information available',
      ),
    );
  }

  Widget _buildEmptyTab({required String title}) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: k.darkOnWhiteTextM,
        ),
      ),
    );
  }

  Widget _buildRelatedProductsTab(ProductDetail product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: product.relatedProducts.isNotEmpty
    ? Column(
        children: product.relatedProducts.map((relatedProduct) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: relatedProduct.productImage?.isNotEmpty ?? false
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        relatedProduct.productImage!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_not_supported),
                    ),
              title: Text(relatedProduct.productName ?? '', style: k.darkOnWhiteTextL),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (relatedProduct.casNumber?.isNotEmpty ?? false)
                    Text('CAS: ${relatedProduct.casNumber}', style: k.darkOnWhiteTextS),
                  if (relatedProduct.iupacName?.isNotEmpty ?? false)
                    Text('IUPAC: ${relatedProduct.iupacName}', style: k.darkOnWhiteTextS),
                ],
              ),
              onTap: () {
                Get.to(
                  () => ProductDetailsPage(),
                  binding: ProductDetailsBindings(),
                  arguments: {
                    'product': relatedProduct,
                  },
                );
              },
            ),
          );
        }).toList(),
      )
    : _buildEmptyTab(
        title: 'No related products available',
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: k.darkOnWhiteTextL.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: k.darkOnWhiteTextS.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: k.darkOnWhiteTextS.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
                  style: k.darkOnWhiteTextM,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}