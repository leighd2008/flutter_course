import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;

  void addProduct(String title, String description, String image, double price) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': 'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg',
      'price': price,
    };
    http.post('https://flutter-products-24a4c.firebaseio.com/products.json', body: json.encode(productData)).then((http.Response response) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);
        //   final Product newProduct = Product(
        //     id: responseData.,
        //     title: title,
        //     description: description,
        //     image: image,
        //     price: price,
        //     userEmail: _authenticatedUser.email,
        //     userId: _authenticatedUser.id);
        // _products.add(newProduct);
        // notifyListeners(); //to enable immediate change on view
        });
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners(); //to enable immediate change on view
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners(); //to enable immediate change on view
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners(); //to enable immediate change on view
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners(); //to enable immediate change on view
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners(); //to enable immediate change on view
  }
}

class UserModel extends ConnectedProductsModel {
  
  void login(String email, String password) {
    _authenticatedUser = User(id: 'akslfj', email: email, password: password);
  }
}

