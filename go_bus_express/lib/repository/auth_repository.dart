import 'package:go_bus_express/data/auth/auth_api.dart';
import 'package:go_bus_express/models/auth/auth_model.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

import '../models/body/auth_body.dart';

abstract class AuthRepository {
  Future<XResult<AuthModel>> login({required LoginBody body});
  Future<XResult<AuthModel>> signup({required SignupBody body});

}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<XResult<AuthModel?>> login({required LoginBody body}) {
    return xResultHandler(() async {
      final res = await api.login(body: body);
      return res.data;
    });

  }
  @override
  Future<XResult<AuthModel>> signup({required SignupBody body}) {
     return xResultHandler(() async {
      return await api.signup(body: body);
    });
  }
}
