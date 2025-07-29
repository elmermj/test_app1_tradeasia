class Product {
  final int? id;
  final String? productImage;
  final String? productName;
  final String? casNumber;
  final String? iupacName;
  final String? hsCode;
  final String? formula;
  final int? priority;

  Product({
    this.id,
    this.productImage,
    this.productName,
    this.casNumber,
    this.iupacName,
    this.hsCode,
    this.formula,
    this.priority,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productImage: json['productimage'] ?? '',
      productName: json['productname'] ?? '',
      casNumber: json['cas_number'] ?? '',
      iupacName: json['iupac_name'] ?? '',
      hsCode: json['hs_code'] ?? '',
      formula: json['formula'] ?? '',
      priority: json['priority'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productimage': productImage,
      'productname': productName,
      'cas_number': casNumber,
      'iupac_name': iupacName,
      'hs_code': hsCode,
      'formula': formula,
      'priority': priority,
    };
  }
} 