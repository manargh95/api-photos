import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos/Module/Screens/HomeScreenController.dart';
import '../../Widgets/AppBar.dart';

final HomeScreenController controller = Get.find();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: photosList(controller),
    );
  }
}

Widget photosList(controller) {
  return Obx(() => controller.isLoading.value
      ? Center(child: CircularProgressIndicator())
      : Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: controller.scrollController,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Colors.white,
                ),
                itemCount: controller.photosList.length,
                itemBuilder: (BuildContext context, int index) {
                  return PhotoCard(
                    imagePath: "${controller.photosList[index].url}",
                  );
                },
              ),
            ),
            if (controller.isLoadingMore.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ));
}

class PhotoCard extends StatelessWidget {
  final String imagePath;

  PhotoCard({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: "$imagePath",
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            height: 150,
          ),
        ),
      ),
    );
  }
}
