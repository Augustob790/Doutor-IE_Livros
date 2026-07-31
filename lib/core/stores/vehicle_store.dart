// import 'package:flutter/material.dart';
// import 'package:precificakm/modules/vehicles/domain/models/vehicle_model.dart';
// import 'package:precificakm/modules/vehicles/domain/usecases/get_vehicles_usecase.dart';

// class VehicleStore extends ChangeNotifier {
//   final GetVehiclesUseCase _getVehiclesUseCase;

//   VehicleStore({required GetVehiclesUseCase getVehiclesUseCase}) : _getVehiclesUseCase = getVehiclesUseCase;

//   List<VehicleModel> _vehicles = [];
//   List<VehicleModel> get vehicles => _vehicles;

//   Future<void> loadVehicles() async {
//     final response = await _getVehiclesUseCase();
//     if (response.isSuccess && response.data != null) {
//       _vehicles = response.data!;
//       notifyListeners();
//     }
//   }

//   VehicleModel? getById(String id) {
//     for (final vehicle in _vehicles) {
//       if (vehicle.id == id) return vehicle;
//     }
//     return null;
//   }

//   void clear() {
//     _vehicles = [];
//     notifyListeners();
//   }
// }
