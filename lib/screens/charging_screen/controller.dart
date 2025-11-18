import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/screens/explorer_screen/controller.dart';

class ChargingController extends GetxController {
  ChargingStatus status = ChargingStatus.none;
  ChargingStats? chargingStats;
  Order? order;

  @override
  void onInit() async{
    super.onInit();

    
    fetchChargingHistory();
  }

  void fetchChargingHistory(){

  }
}

