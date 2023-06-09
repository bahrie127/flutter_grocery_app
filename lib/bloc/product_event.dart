part of 'product_bloc.dart';

abstract class ProductEvent {}

class GetProductEvent extends ProductEvent {}
class LoadMoreProductEvent extends ProductEvent {}
