import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultListingShimmer extends StatelessWidget with AppMixin {

  final EdgeInsets? padding;

  const DefaultListingShimmer({super.key, this.padding = const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  )});

  @override
  Widget build(BuildContext context) {
    final Color whiteShimmer = Colors.white.withOpacity(0.3);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.7),
        highlightColor: Colors.grey[100]!.withOpacity(.5),
        child: ListView.separated(
          padding: padding,
          itemCount: 20,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 6);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                    color: whiteShimmer,
                    height: 35,
                    width: 35,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container(
                              color: whiteShimmer,
                              height: 14,
                            )),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              color: whiteShimmer,
                              height: 14,
                              width: 60,
                            ),
                          ],
                        ),
                        const SizedBox(height: 11),
                        Row(
                          children: [
                            Expanded(child: Container(
                              color: whiteShimmer,
                              height: 14,
                            )),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              color: whiteShimmer,
                              height: 14,
                              width: 60,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DefaultOrderListingShimmer extends StatelessWidget with AppMixin {

  final EdgeInsets? padding;

  const DefaultOrderListingShimmer({super.key, this.padding = const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  )});

  @override
  Widget build(BuildContext context) {
    final Color whiteShimmer = Colors.white.withOpacity(0.3);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.7),
        highlightColor: Colors.grey[100]!.withOpacity(.5),
        child: ListView.separated(
          padding: padding,
          itemCount: 20,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 6);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        color: whiteShimmer,
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container(
                                  color: whiteShimmer,
                                  height: 14,
                                )),
                              ],
                            ),
                            const SizedBox(height: 11),
                            Row(
                              children: [
                                Expanded(child: Container(
                                  color: whiteShimmer,
                                  height: 14,
                                )),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: whiteShimmer,
                                  height: 14,
                                  width: 60,
                                ),
                              ],
                            ),
                            const SizedBox(height: 11),
                            Row(
                              children: [
                                Expanded(child: Container(
                                  color: whiteShimmer,
                                  height: 14,
                                )),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: whiteShimmer,
                                  height: 14,
                                  width: 60,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    color: whiteShimmer,
                    height: 14,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    color: whiteShimmer,
                    height: 14,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    color: whiteShimmer,
                    height: 14,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderDetailShimmer extends StatelessWidget with AppMixin {

  final EdgeInsets? padding;

  const OrderDetailShimmer({super.key, this.padding = const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  )});

  @override
  Widget build(BuildContext context) {
    final Color whiteShimmer = Colors.white.withOpacity(0.3);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SingleChildScrollView(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.7),
          highlightColor: Colors.grey[100]!.withOpacity(.5),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteShimmer,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteShimmer,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      color: whiteShimmer,
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                color: whiteShimmer,
                                height: 14,
                                width: 60,
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                color: whiteShimmer,
                                height: 14,
                                width: 60,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Container(
                  color: whiteShimmer,
                  height: 14,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      color: whiteShimmer,
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                color: whiteShimmer,
                                height: 14,
                                width: 60,
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Expanded(child: Container(
                                color: whiteShimmer,
                                height: 14,
                              )),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                color: whiteShimmer,
                                height: 14,
                                width: 60,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}