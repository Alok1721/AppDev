import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../models/products.dart';
import 'dashboard_repo.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepo dashboardRepo;
  DashboardResponse? dashboardData;
  bool isLoading = false;
  String? errorMessage;

  DashboardViewModel({required this.dashboardRepo});

  Future<void> fetchDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboardData = await dashboardRepo.fetchDashboardData();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}