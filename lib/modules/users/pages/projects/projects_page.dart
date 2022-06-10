import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import '../../../../common/loading_widget.dart';

class ProjectsPage extends GetView<HomeController> {
  const ProjectsPage({Key? key}) : super(key: key);
  static const id = '/ProjectsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomeController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                const Text("projects"),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
