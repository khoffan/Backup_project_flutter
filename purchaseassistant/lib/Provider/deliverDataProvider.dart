import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/matchmodel.dart';

class DeliveryDataProvider extends ChangeNotifier{
  DeliveryData _deliveryData = DeliveryData("", "");

  DeliveryData get deliveryData => _deliveryData;

  void updateDeliveryData(DeliveryData newData){
    _deliveryData = newData;
    notifyListeners();
  }
}