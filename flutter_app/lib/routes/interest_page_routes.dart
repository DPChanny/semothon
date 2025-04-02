import 'package:flutter/material.dart';
import 'package:flutter_app/pages/interest_selection_pages/interest_category_selection_page.dart';
import 'package:flutter_app/pages/interest_selection_pages/interest_selection_page.dart';

class InterestPageRouteNames {
  static const interestSelectionPage = '/interest_selection_page';
  static const interestCategorySelectionPage =
      '/interest_category_selection_page';
}

final Map<String, WidgetBuilder> interestPageRoutes = {
  InterestPageRouteNames.interestSelectionPage:
      (context) => const InterestSelectionPage(),
  InterestPageRouteNames.interestCategorySelectionPage:
      (context) => const InterestCategorySelectionPage(),
};
