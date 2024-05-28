import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/app/pages/home/controller.dart';

import 'package:get/get.dart';

class HomeView extends GetResponsiveView<HomeController> {
  HomeView({super.key}) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(
      () => Scaffold(
        appBar: controller.isLoading.value ? AppBar() : appbar(),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : body(),
      ),
    ));
  }

  body() {
    return Obx(() => controller.subCategories.isNotEmpty &&
            controller.subCategories[0]["SubCategories"] != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                ...controller.subCategories[0]["SubCategories"]
                    .map((element) => subCategoryListView(element))
              ],
            ),
          )
        : const Center(child: Text("No data available")));
  }

  appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      actions: const [
        Icon(
          Icons.filter_alt_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.search_rounded,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
      ],
      bottom: TabBar(
        isScrollable: true,
        indicatorPadding: EdgeInsets.zero,
        indicator: const BoxDecoration(),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        controller: controller.tabController,
        onTap: (index) async {
          controller.isTabLoading.value = true;
          controller.selectedIndex.value = index;
          await controller.getSubCategory();
          controller.isTabLoading.value = false;
        },
        tabs: [
          ...controller.categories.map((element) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(element["Name"])))
        ],
      ),
    );
  }

  subCategoryListView(data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                data["Name"],
                style: const TextStyle(fontSize: 16),
              )),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              itemCount: data["Product"].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      SquareNetworkImage(
                        imageUrl: data["Product"][index]["ImageName"],
                        height: 120,
                        width: 150,
                        priceCode: data["Product"][index]["PriceCode"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        data["Product"][index]["Name"],
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

class SquareNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final String priceCode;

  const SquareNetworkImage(
      {required this.imageUrl,
      required this.height,
      required this.width,
      required this.priceCode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.blue[400],
            ),
            padding: const EdgeInsets.all(3),
            child: Text(
              priceCode,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
