
import 'package:flutter/foundation.dart';
import 'package:purchaseassistant/models/matchmodel.dart';

class DeliveryDataProvider with ChangeNotifier{
  List<String> _deliveryData = [];

  List<String> getDeliveryData() {
    print(_deliveryData);
    return _deliveryData;
  }

  void updateDeliveryData(List<String> data){
    print("Updating delivery data: ${data}");
    _deliveryData = data;
    print("deliveryData ${_deliveryData}");
    notifyListeners();
  }
}