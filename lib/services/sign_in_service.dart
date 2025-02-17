import 'package:project/helper/api.dart';
import 'package:project/models/sign_in_model.dart';

class SignInService {
  Future<List<SignInModel>> signIn({
    required String email,
    required String password,
  }) async {
    List<dynamic> data = await Api().get(
      url:
          'https://748e-2c0f-fc88-5-91d-948f-a69e-1aec-58c3.ngrok-free.app/Admine/Doctor/apiAllDoctor',
    );
    List<SignInModel> adminList = [];
    for (int i = 0; i < data.length; i++) {
      adminList.add(SignInModel.fromJson(data[i]));
    }
    return adminList;
  }
}
