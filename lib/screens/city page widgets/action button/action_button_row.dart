import 'package:flutter/material.dart';
import 'package:travel_app/screens/city%20page%20widgets/action%20button/action_button_class.dart';
// import 'package:travel_app/screens/map_launch.dart';
import 'package:travel_app/screens/review%20page/review%20making%20page/make_a_review_page_widget.dart';

class ActionButtonsRow extends StatelessWidget {
  final String cityName;
  final String cityId;

  const ActionButtonsRow({
    super.key,
    required this.cityName,
    required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              icon: Icons.edit,
              label: 'Add Review',
              color: Colors.green,
              onPressed: () => _showReviewSheet(context),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MakeReviewPage(cityId: cityId),
        ),
      ),
    );
  }
}
