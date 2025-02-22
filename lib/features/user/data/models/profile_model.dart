class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String email;
  final String phone;
  final String office;
  final String department;
  final String experience;
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
      id: json['IdDoctor'],
      name: json['nameDoctor'],
      specialization: json['specializationDoctor'],
      email: json['emailDoctor'],
      phone: json['phoneDoctor'],
      office: json['officeDoctor'],
      department: json['departmentDoctor'],
      experience: json['expDoctor'],
      imageUrl: 'https://98b3-2c0f-fc88-5-b4ad-595e-dcc0-953e-40f7.ngrok-free.app/images/${json['image']['filename']}',
    );
  }
}