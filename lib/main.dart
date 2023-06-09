import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_grocery_ui/item_widget.dart';

import 'bloc/product_bloc.dart';
import 'data.dart';
import 'models/product.dart';

void main() {
  Bloc.observer = GroceryBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(GetProductEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = ScrollController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<ProductBloc>().add(LoadMoreProductEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: const Text(
          'Online Store',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.search,
                color: Colors.black,
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 3,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(GetProductEvent());
        },
        child: BlocListener<ProductBloc, ProductSuccess>(
          listener: (context, state) {
            if (state.status == Status.loading) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Loading More...')));
            }
          },
          child: BlocBuilder<ProductBloc, ProductSuccess>(
            builder: (context, state) {
              if (state.status == Status.initial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.status == Status.success) {
                products = state.products!;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // return Container(
                //   padding: const EdgeInsets.all(10),
                //   child: GridView.builder(
                //     controller: controller,
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       mainAxisSpacing: 10,
                //       crossAxisSpacing: 10,
                //       crossAxisCount: 2,
                //       childAspectRatio: 0.65,
                //     ),
                //     itemBuilder: (context, index) {
                //       return ItemWidget(product: products[index]);
                //     },
                //     itemCount: products.length,
                //   ),
                // );
              }
              return Container(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  controller: controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    return ItemWidget(product: products[index]);
                  },
                  itemCount: products.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GroceryBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
