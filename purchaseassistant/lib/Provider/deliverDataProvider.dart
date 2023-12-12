
import 'package:flutter/foundation.dart';
import 'package:purchaseassistant/models/matchmodel.dart';

class DeliveryDataProvider with ChangeNotifier{
  DeliveryData _deliveryData = DeliveryData();

  DeliveryData getDeliveryData() {
    return _deliveryData;
  }

  String getDeliveyDataCusid(){
    return _deliveryData.cusid.toString();
  }
  String getDeliveyDataRiderid(){
    return _deliveryData.riderid.toString();
  }

  void updateDeliveryData(DeliveryData data){
    _deliveryData = data;
    notifyListeners();
  }
}