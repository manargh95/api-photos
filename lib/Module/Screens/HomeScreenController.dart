import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos/Model/PhotosT_Model.dart';
import '../../../Api/DioHelper.dart';

class HomeScreenController extends GetxController {
  RxList<PhotosT_Model> photosList = <PhotosT_Model>[].obs;
  RxBool isLoading = false.obs;

  void fetchData() async {
    isLoading.value = true;

    try {
      final dio = DioHelper();

      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/photos'
      );
      if (response.statusCode == 200) {
        final responseData = response.data as List<dynamic>;
        final testModels = responseData.map((json) => PhotosT_Model.fromJson(json)).toList();
        photosList.value = testModels;
      } else {
        print('Error');
      }
    } catch (error) {
      print(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchData();
    addLoadMoreTrigger();
    super.onInit();
  }

  late ScrollController scrollController = ScrollController();
  bool stopLoadMore = false;
  RxBool isLoadingMore = false.obs;

  addLoadMoreTrigger() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        loadMore();
      }
    });
  }

  loadMore() async {
    if (stopLoadMore) return;
    RxList<PhotosT_Model>? tPhotos;
    isLoadingMore.value = true;
    update();
    final dio = DioHelper();

    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/photos'
      );
      if (response.statusCode == 200) {
        final responseData = response.data as List<dynamic>;
        final testModels = responseData.map((json) => PhotosT_Model.fromJson(json)).toList();
        tPhotos = testModels.obs;
      }
    } catch (error) {
      print(error.toString());
    } finally {
      isLoadingMore.value = false;
    }

    if (tPhotos!.isEmpty) stopLoadMore = true;
    photosList.addAll(tPhotos!);

    update();
  }
}


