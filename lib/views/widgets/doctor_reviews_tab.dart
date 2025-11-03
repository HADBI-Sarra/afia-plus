import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class DoctorReviewsTab extends StatelessWidget {
  const DoctorReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample reviews
    final reviews = [
      Review(
        name: "Sarah H.",
        date: "Oct 2, 2025",
        comment:
            "Dr. Yousfi is amazing! Very professional and caring. Highly recommend.",
      ),
      Review(
        name: "Ahmed D.",
        date: "Sep 25, 2025",
        comment:
            "Great experience! Explained everything clearly and made me feel comfortable.",
      ),
      Review(
        name: "Anfel R.",
        date: "Sep 15, 2025",
        comment: "Friendly and knowledgeable. I felt very supported during my online meet.",
      ),
      Review(
        name: "Besmala H.",
        date: "Oct 2, 2025",
        comment:
            "Dr.ousfi is really outstanding. He explained everything in detail. ",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "13 reviews",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.comment, color: darkGreenColor),
                const SizedBox(width: 5),
                Text(
                  "Leave a review",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: darkGreenColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reviews List
        ...reviews.map((review) => Column(
              children: [
                ReviewItem(review: review),
                const SizedBox(height: 12),
                // Thin grey divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(color: lightGreyColor, thickness: 1),
                ),
                const SizedBox(height: 12),
              ],
            )),
      ],
    );
  }
}

class Review {
  final String name;
  final String date;
  final String comment;

  Review({required this.name, required this.date, required this.comment});
}

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circular avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: greyColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: greyColor, size: 28),
        ),
        const SizedBox(width: 12),
        // Review content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + Date + Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        review.date,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: greyColor),
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(Icons.star, color: darkGreenColor, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
