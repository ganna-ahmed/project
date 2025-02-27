class Doctor {
  final int id;
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
      id: json['IdDoctor'] is int
          ? json['IdDoctor']
          : int.tryParse(json['IdDoctor'].toString()) ?? 0,
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
          ? 'https://ac65-2a09-bac5-d57b-1eb-00-31-111.ngrok-free.app/images/${json['image']['filename']}'
          : 'https://ac65-2a09-bac5-d57b-1eb-00-31-111.ngrok-free.app/default_image.jpg',
    );
  }
}
