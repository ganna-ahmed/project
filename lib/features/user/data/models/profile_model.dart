// class Doctor {
//   final String id;
//   final String name;
//   final String specialization;
//   final String email;
//   final String phone;
//   final String office;
//   final String department;
//   final int experience;
//   final String imageUrl;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     required this.email,
//     required this.phone,
//     required this.office,
//     required this.department,
//     required this.experience,
//     required this.imageUrl,
//   });

//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       id: json['IdDoctor'] is int
//           ? json['IdDoctor']
//           : int.tryParse(json['IdDoctor'].toString()) ?? 0,
//       name: json['nameDoctor'] ?? '',
//       specialization: json['specializationDoctor'] ?? '',
//       email: json['emailDoctor'] ?? '',
//       phone: json['phoneDoctor'] ?? '',
//       office: json['officeDoctor'] ?? '',
//       department: json['departmentDoctor'] ?? '',
//       experience: json['expDoctor'] is int
//           ? json['expDoctor']
//           : int.tryParse(json['expDoctor'].toString()) ?? 0,
//       imageUrl: json['image'] != null && json['image']['filename'] != null
//           ? 'https://4882-156-210-92-118.ngrok-free.app/images/${json['image']['filename']}'
//           : 'https://4882-156-210-92-118.ngrok-free.app/default_image.jpg',
//     );
//   }
// }

class Doctor {
  final String id; // هذا هو _id الحقيقي من الـ API
  final String name;
  final String specialization;
  final String email;
  final String phone;
  final String office;
  final String department;
  final int experience;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
    required this.phone,
    required this.office,
    required this.department,
    required this.experience,
    required this.imageUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '', // استرجاع _id الصحيح
      name: json['nameDoctor'] ?? '',
      specialization: json['specializationDoctor'] ?? '',
      email: json['emailDoctor'] ?? '',
      phone: json['phoneDoctor'] ?? '',
      office: json['officeDoctor'] ?? '',
      department: json['departmentDoctor'] ?? '',
      experience: json['expDoctor'] is int
          ? json['expDoctor']
          : int.tryParse(json['expDoctor'].toString()) ?? 0,
      imageUrl: json['image'] != null && json['image']['filename'] != null
          ? 'https://843c-2c0f-fc88-5-597-49a2-fc16-b990-4a8b.ngrok-free.app/images/${json['image']['filename']}'
          : 'https://843c-2c0f-fc88-5-597-49a2-fc16-b990-4a8b.ngrok-free.app/default_image.jpg',
    );
  }
}
