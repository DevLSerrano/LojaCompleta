import 'package:app_loja/datas/cart_product.dart';
import 'package:app_loja/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  String coupomCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    // Future.delayed(Duration(seconds: ,));
    // print(user.isLoggedIn());
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder()async{
    if(products.length == 0)
      return null;
    
    isLoading =true;
    notifyListeners();

    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder= await Firestore.instance.collection('orders').add(
      {
        'clienteId': user.firebaseUser.uid,
        'products': products.map((cartProduct)=> cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productPrice': productPrice,
        'discountPrice': discount,
        'totalPrice': productPrice - discount + shipPrice,
        'status': 1
      }
    );

    await Firestore.instance.collection('users').document(user.firebaseUser.uid)
    .collection('orders').document(refOrder.documentID).setData(
      {
        'orderId': refOrder.documentID,
        'dateOrder': DateTime.now(),
      }
    );

    QuerySnapshot query= await Firestore.instance.collection('users').document(user.firebaseUser.uid)
    .collection('cart').getDocuments();

    for( DocumentSnapshot doc in query.documents){ //deletar todos item do carrinho no firebase
      doc.reference.delete();
    }

    products.clear();
    coupomCode=null;
    discountPercentage =0;
    isLoading =false;
    notifyListeners();

    return refOrder.documentID;

  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupom(String coupomCode, int discountPercentage) {
    this.coupomCode = coupomCode;
    this.discountPercentage = discountPercentage;
  }

  void _loadCartItems() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products = querySnapshot.documents
        .map((doc) => CartProduct.fromDocument(doc))
        .toList();

    // print(products.toString());

    notifyListeners();
  }
}
