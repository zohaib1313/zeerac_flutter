import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';
import '../models/blog_response_model.dart';

class BlogListingController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<BlogModel?> filteredItemList = <BlogModel?>[].obs;
  TextEditingController searchController = TextEditingController();
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxList<BlogModel?> blogsList = <BlogModel>[].obs;

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        if (hasNewPage) {
          printWrapped('reached at then end');
          loadBlogs();
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  void searchFromList() {
    filteredItemList.clear();
    if (searchController.text.isEmpty) {
      filteredItemList.addAll(blogsList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in blogsList) {
        if (((element?.authorName ?? "null").toLowerCase()).contains(query) ||
            ((element?.tags ?? "null").toLowerCase()).contains(query)) {
          filteredItemList.add(element);
        }
      }
    }
  }

  void loadBlogs({bool showAlert = false}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "page": pageToLoad.toString(),
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadBlogs,
              body: body,
            ),
            create: () => APIResponse<BlogResponseModel>(
                create: () => BlogResponseModel()),
            apiFunction: loadBlogs)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        blogsList.addAll(response.response!.data!.results!);
        filteredItemList.addAll(response.response!.data!.results!);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
    });
  }
}
