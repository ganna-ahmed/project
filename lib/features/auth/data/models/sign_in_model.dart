import 'package:project/constants.dart';

class SignInModel {
  final String id;
  final String nameDoctor;
  final String emailDoctor;
  final String phoneDoctor;
  final String specializationDoctor;
  final String officeDoctor;
  final String departmentDoctor;
  final String expDoctor;
  final String idDoctor;
  final String passDoctor;
  final ImageModel image;

  SignInModel({
    required this.id,
    required this.nameDoctor,
    required this.emailDoctor,
    required this.phoneDoctor,
    required this.specializationDoctor,
    required this.officeDoctor,
    required this.departmentDoctor,
    required this.expDoctor,
    required this.idDoctor,
    required this.passDoctor,
    required this.image,
  });

  factory SignInModel.fromJson(jsonData) {
    return SignInModel(
        id: jsonData['_id'],
        nameDoctor: jsonData['nameDoctor'],
        emailDoctor: jsonData['emailDoctor'],
        phoneDoctor: jsonData['phoneDoctor'],
        specializationDoctor: jsonData['specializationDoctor'],
        officeDoctor: jsonData['officeDoctor'],
        departmentDoctor: jsonData['departmentDoctor'],
        expDoctor: jsonData['expDoctor'],
        idDoctor: jsonData['IdDoctor'],
        passDoctor: jsonData['passDoctor'],
        image: ImageModel.fromjson(jsonData['image']));
  }
}

class ImageModel {
  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;
  final String destination;
  final String filename;
  final String path;
  final int size;

  ImageModel({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.destination,
    required this.filename,
    required this.path,
    required this.size,
  });

  factory ImageModel.fromjson(jsonData) {
    // إصلاح مشكلة الـ path
    String imagePath;

    if (jsonData != null && jsonData['filename'] != null) {
      // الـ filename موجود مباشرة في jsonData
      imagePath = '$kBaseUrl/images/${jsonData['filename']}';
    } else {
      // استخدام صورة افتراضية
      imagePath = '$kBaseUrl/default_image.jpg';
    }

    return ImageModel(
      fieldname: jsonData['fieldname'] ?? '',
      originalname: jsonData['originalname'] ?? '',
      encoding: jsonData['encoding'] ?? '',
      mimetype: jsonData['mimetype'] ?? '',
      destination: jsonData['destination'] ?? '',
      filename: jsonData['filename'] ?? '',
      path: imagePath,
      size: jsonData['size'] ?? 0,
    );
  }
}