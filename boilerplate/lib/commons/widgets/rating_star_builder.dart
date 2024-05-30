import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

typedef RatingChangeCallBack = Function(int rate);

class RatingStarBuilder extends StatefulWidget {
  final int total;
  final int? rate;
  final double size;
  final bool disable;
  final RatingChangeCallBack? ratingChangeCallBack;

  const RatingStarBuilder(
      {super.key,
        this.size = 31,
        required this.total,
        this.rate,
        this.disable = false,
        this.ratingChangeCallBack});

  @override
  State<RatingStarBuilder> createState() => _RatingStarBuilderState();
}

class _RatingStarBuilderState extends State<RatingStarBuilder> with AppMixin {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.rate ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 1; i <= widget.total; i++)
          GestureDetector(
            onTap: widget.disable ? null : () {
              if (index != i) {
                setState(() {
                  index = i;
                });
                widget.ratingChangeCallBack?.call(index);
              }
            },
            child: HeroIcon(
              HeroIcons.star,
              color: AppColors.bananaPepper,
              size: widget.size,
              style: i <= index ? HeroIconStyle.solid : HeroIconStyle.outline,
            ),
          )
      ],
    );
  }
}
