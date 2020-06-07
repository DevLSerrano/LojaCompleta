import 'package:app_loja/tabs/home_tab.dart';
import 'package:app_loja/tabs/orders_tab.dart';
import 'package:app_loja/tabs/place_tab.dart';
import 'package:app_loja/tabs/products_tab.dart';
import 'package:app_loja/widgets/cart_button.dart';
import 'package:app_loja/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,

          ),
          body: PlaceTab(),
          drawer: CustomDrawer(_pageController),
        ),
        
        Scaffold(appBar: AppBar(
          title: Text('Meus Pedidos'),
          centerTitle: true,

        ),
        body: OrdersTab(),
        drawer: CustomDrawer(_pageController),
        ),
        
      ],
    );
  }
}
