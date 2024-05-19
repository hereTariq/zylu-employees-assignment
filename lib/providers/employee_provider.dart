import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zylu_employee_assignment/models/employee.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  Future<void> fetchEmployees() async {
    final response =
        await http.get(Uri.parse('http://192.168.70.191:3000/employees'));
    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      // print(jsonData);

      _employees = jsonData.map((jsonEmployee) {
        return Employee.fromJson(jsonEmployee);
      }).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load Employees.');
    }
  }
}
