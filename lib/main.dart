import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zylu_employee_assignment/models/employee.dart';
import 'package:zylu_employee_assignment/providers/employee_provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EmployeeScreen(),
    );
  }
}

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Employee> _employees = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _fetchEmployees();
    super.didChangeDependencies();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _isLoading = true;
    });
    final empData = Provider.of<EmployeeProvider>(context, listen: false);
    await empData.fetchEmployees();

    setState(() {
      _isLoading = false;
      _employees = empData.employees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
        // backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
              ? const Center(
                  child: Text('NO EMPLOYEES FOUND!'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    final emp = _employees[index];
                    final yearOfService =
                        DateTime.now().difference(emp.joiningDate!).inDays ~/
                            365;
                    print('yearOfService $yearOfService');
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            emp.name![0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          emp.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                            'Joined on: ${emp.joiningDate!.toLocal().toString().split(' ')[0]}'),
                        trailing: yearOfService > 5 && emp.isActive!
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}
