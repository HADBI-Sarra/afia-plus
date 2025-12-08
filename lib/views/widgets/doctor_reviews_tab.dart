import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:afia_plus_app/data/models/review.dart';
import 'package:afia_plus_app/logic/cubits/doctors/doctors_cubit.dart';
import 'package:intl/intl.dart';

class DoctorReviewsTab extends StatefulWidget {
  final Doctor doctor;
  const DoctorReviewsTab({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorReviewsTab> createState() => _DoctorReviewsTabState();
}

class _DoctorReviewsTabState extends State<DoctorReviewsTab> {
  List<Review> reviews = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final cubit = context.read<DoctorsCubit>();
    final result = await cubit.getReviewsByDoctorId(widget.doctor.userId ?? 0);
    
    if (mounted) {
      setState(() {
        if (result.state && result.data != null) {
          reviews = result.data!;
        } else {
          error = result.message;
        }
        loading = false;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyColor),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.comment, color: darkGreenColor),
                const SizedBox(width: 5),
                Text(
                  "Leave a review",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: darkGreenColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reviews List
        if (reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No reviews yet. Be the first to review!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...reviews.map((review) => Column(
                children: [
                  ReviewItem(review: review),
                  const SizedBox(height: 12),
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

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({Key? key, required this.review}) : super(key: key);

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: greyColor.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(Icons.person, color: greyColor, size: 28),
        ),
        const SizedBox(width: 12),
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
                        review.patientName ?? "Anonymous",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(review.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greyColor),
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < review.rating ? darkGreenColor : greyColor.withOpacity(0.3),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              if (review.comment != null && review.comment!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  review.comment!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: blackColor),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
