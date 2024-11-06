import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/profile_top_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Service/Api/Medicine/medicine_api.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/profile_detail_cell.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProfileTopView extends StatelessWidget {
  const ProfileTopView({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileTopController controller = ProfileTopController(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    String lastName = 'のりた';
    String firstName = 'しおき';
    // todo: controller出来たら消す
    return CustomScaffold(
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () async {
                List<Medicine>? value = await MedicineApi().getMedicineList();
                print(value?[0].reminders[0].reminderId);
              },
              child: Text('GET MEDICINE LIST')),
        ],
      ),
    );
  }
}
