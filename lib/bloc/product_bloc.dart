import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductSuccess> {
  ProductBloc() : super(ProductSuccess(status: Status.initial)) {
    on<GetProductEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=10'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final products = productFromJson(response.body);
      emit(
        state.copyWith(
          size: 10,
          status: Status.success,
          products: products,
          page: 1,
          hasMore: products.length > 10,
        ),
      );
    });

    on<LoadMoreProductEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      // print(successState.toString());
      final response = await http.get(
        Uri.parse(
            'https://api.escuelajs.co/api/v1/products?offset=${state.page! * state.size!}&limit=${state.size!}'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final products = productFromJson(response.body);
      emit(
        state.copyWith(
          products: state.products! + products,
          page: state.page! + 1,
          hasMore: products.length > state.size!,
        ),
      );
    });
  }
}
