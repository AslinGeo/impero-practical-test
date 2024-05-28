import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ignore: deprecated_member_use
class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final String url =
      "http://esptiles.imperoserver.in/api/API/Product/DashBoard";
  final Map categoryBody = {
    "CategoryId": 0,
    "DeviceManufacturer": "Google",
    "DeviceModel": "Android SDK built for x86",
    "DeviceToken": " ",
    "PageIndex": 1
  };

  final Map subCategoryBody = {"CategoryId": 56, "PageIndex": 2};
  RxList categories = [].obs;
  RxList subCategories = [].obs;
  late TabController tabController;
  RxBool isLoading = true.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isTabLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  init() async {
    await getCategory();
    await getSubCategory();
  }

  getCategory() async {
    try {
      var response = await postMethod(categoryBody);
      if (response != null) {
        response["Result"]["Category"]
            .map((data) => categories.add(data))
            .toList();
        tabController = TabController(length: categories.length, vsync: this);
      }

      isLoading.value = false;
    } catch (e) {
      return e;
    }
  }

  getSubCategory() async {
    try {
      subCategoryBody["CategoryId"] = categories[selectedIndex.value]["Id"];
      var response = await postMethod(subCategoryBody);
      subCategories.clear();
      if (response != null) {
        subCategories.clear();
        response["Result"]["Category"]
            .map((data) => subCategories.add(data))
            .toList();
      }
    } catch (e) {
      return e;
    }
  }

  postMethod(body) async {
    try {
      var result = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      return jsonDecode(result.body);
    } catch (e) {
      return null;
    }
  }
}
