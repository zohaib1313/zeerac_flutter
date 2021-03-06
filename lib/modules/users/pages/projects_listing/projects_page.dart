import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/projects_controller.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/projects_listing/projects_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/loading_widget.dart';

class ProjectsPage extends GetView<ProjectsController>
    with ProjectWidgetsMixin {
  const ProjectsPage({Key? key}) : super(key: key);
  static const id = '/ProjectsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ProjectsController>(
        initState: (state) {
          if (controller.projectsList.isEmpty) {
            controller.loadProjects();
            controller.searchController.addListener(() {
              controller.searchFromList();
            });
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.projectsList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Project Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.loadProjects(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryBlueColor),
                            ),
                          ),
                        ],
                      ))
                    : Column(
                        children: [
                          myAppBar(goBack: false, title: 'Projects', actions: [
                            MyAnimSearchBar(
                                rtl: true,
                                width: MediaQuery.of(context).size.width,
                                textController: controller.searchController,
                                closeSearchOnSuffixTap: true,
                                onSuffixTap: () {
                                  controller.searchController.clear();
                                }),
                          ]),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: NotificationListener(
                                onNotification: controller.onScrollNotification,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.filteredItemList.length,
                                  itemBuilder: (context, index) {
                                    return projectWidget(
                                        controller.filteredItemList[index]!);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
