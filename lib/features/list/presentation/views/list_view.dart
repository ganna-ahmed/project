import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController materialController = TextEditingController();
  final List<String> departments = ["CSE", "ESC", "Power"];
  String selectedDepartment = "CSE";

  // القائمة التي تحتوي على المواد
  List<Map<String, String>> materials = [
    {"name": "Java", "department": "CSE"},
    {"name": "Python", "department": "CSE"},
    {"name": "AI", "department": "CSE"},
    {"name": "Network", "department": "CSE"},
    {"name": "Control", "department": "ESC"},
    {"name": "Fiber", "department": "ESC"},
  ];

  // دالة لإضافة مادة جديدة
  void addMaterial() {
    if (materialController.text.isNotEmpty) {
      setState(() {
        materials.add({
          "name": materialController.text,
          "department": selectedDepartment
        });
        materialController.clear();
      });
    }
  }

  // دالة لحذف مادة من القائمة
  void removeMaterial(int index) {
    setState(() {
      materials.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Doctor _id: ${context.watch<LoginCubit>().doctorDatabaseId ?? 'No doctor logged in'}"
          "Material list by Department",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2262C6),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Color(0xff727272AB), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: materialController,
                      decoration: InputDecoration(
                        hintText: "Add material",
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  DropdownButton<String>(
                    value: selectedDepartment,
                    underline: SizedBox(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDepartment = newValue!;
                      });
                    },
                    items: departments
                        .map((dept) => DropdownMenuItem(
                              value: dept,
                              child: Text(
                                dept,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xff2262C6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 15),
                      onPressed: addMaterial,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  final material = materials[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(material['name']!,
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          SizedBox(width: 10),
                          Text("(${material['department']})",
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                      trailing: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xffF0394E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_sweep,
                              color: Colors.white, size: 18),
                          onPressed: () => removeMaterial(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
