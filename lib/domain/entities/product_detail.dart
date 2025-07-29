import 'product.dart';

class ProductDetailResponse {
  final bool status;
  final ProductDetailData data;
  final String message;

  ProductDetailResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      status: json['status'] ?? false,
      data: ProductDetailData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class ProductDetailData {
  final ProductDetail productDetail;

  ProductDetailData({
    required this.productDetail,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      productDetail: ProductDetail.fromJson(json['product_detail'] ?? {}),
    );
  }
}

class ProductDetail {
  final String productImage;
  final String productName;
  final String iupacName;
  final String casNumber;
  final String hsCode;
  final String formula;
  final String tdsFile;
  final String msdsFile;
  final String description;
  final String application;
  final int phyAppearId;
  final String commonNames;
  final int prodindId;
  final int categoryId;
  final List<ProductIndustry> productIndustries;
  final String prodindName;
  final String categoryName;
  final List<Product> relatedProducts;
  final SalesAssociateInfo? salesAssociateInfo;
  final BasicInfo basicInfo;

  ProductDetail({
    required this.productImage,
    required this.productName,
    required this.iupacName,
    required this.casNumber,
    required this.hsCode,
    required this.formula,
    required this.tdsFile,
    required this.msdsFile,
    required this.description,
    required this.application,
    required this.phyAppearId,
    required this.commonNames,
    required this.prodindId,
    required this.categoryId,
    required this.productIndustries,
    required this.prodindName,
    required this.categoryName,
    required this.relatedProducts,
    this.salesAssociateInfo,
    required this.basicInfo,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productImage: json['productimage'] ?? '',
      productName: json['productname'] ?? '',
      iupacName: json['iupac_name'] ?? '',
      casNumber: json['cas_number'] ?? '',
      hsCode: json['hs_code'] ?? '',
      formula: json['formula'] ?? '',
      tdsFile: json['tds_file'] ?? '',
      msdsFile: json['msds_file'] ?? '',
      description: json['description'] ?? '',
      application: json['application'] ?? '',
      phyAppearId: json['phy_appear_id'] ?? 0,
      commonNames: json['common_names'] ?? '',
      prodindId: json['prodind_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      productIndustries: (json['productIndustries'] as List<dynamic>?)
              ?.map((item) => ProductIndustry.fromJson(item))
              .toList() ??
          [],
      prodindName: json['prodind_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      relatedProducts: (json['related_product'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      salesAssociateInfo: json['sales_associate_info'] != null
          ? SalesAssociateInfo.fromJson(json['sales_associate_info'])
          : null,
      basicInfo: BasicInfo.fromJson(json['basic_info'] ?? {}),
    );
  }
}

class ProductIndustry {
  final int id;
  final int prodindId;
  final int languageId;
  final String prodindName;
  final String prodindDesc;
  final String prodindUrl;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ProductIndustry({
    required this.id,
    required this.prodindId,
    required this.languageId,
    required this.prodindName,
    required this.prodindDesc,
    required this.prodindUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProductIndustry.fromJson(Map<String, dynamic> json) {
    return ProductIndustry(
      id: json['id'] ?? 0,
      prodindId: json['prodind_id'] ?? 0,
      languageId: json['language_id'] ?? 0,
      prodindName: json['prodind_name'] ?? '',
      prodindDesc: json['prodind_desc'] ?? '',
      prodindUrl: json['prodind_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }
}

class SalesAssociateInfo {
  final int? id;
  final String? cometChatUserId;

  SalesAssociateInfo({
    this.id,
    this.cometChatUserId,
  });

  factory SalesAssociateInfo.fromJson(Map<String, dynamic> json) {
    return SalesAssociateInfo(
      id: json['id'],
      cometChatUserId: json['comet_chat_user_id'],
    );
  }
}

class BasicInfo {
  final String phyAppearName;
  final String packagingName;
  final String commonNames;

  BasicInfo({
    required this.phyAppearName,
    required this.packagingName,
    required this.commonNames,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      phyAppearName: json['phy_appear_name'] ?? '',
      packagingName: json['packaging_name'] ?? '',
      commonNames: json['common_names'] ?? '',
    );
  }
} 