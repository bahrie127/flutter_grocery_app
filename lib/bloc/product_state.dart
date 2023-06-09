part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

enum Status {
  initial,
  loading,
  success,
  error,
}

class ProductSuccess extends ProductState {
  Status? status;
  List<Product>? products;
  int? page = 0;
  int? size = 10;
  bool? hasMore = true;
  ProductSuccess({
    this.status,
    this.products,
    this.page,
    this.size,
    this.hasMore,
  });
  

  @override
  String toString() {
    return 'ProductSuccess(products: $products, page: $page, size: $size, hasMore: $hasMore)';
  }

  ProductSuccess copyWith({
    Status? status,
    List<Product>? products,
    int? page,
    int? size,
    bool? hasMore,
  }) {
    return ProductSuccess(
      status: status ?? this.status,
      products: products ?? this.products,
      page: page ?? this.page,
      size: size ?? this.size,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
