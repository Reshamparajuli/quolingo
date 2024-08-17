import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:finalproject/core/failure/failure.dart';
import 'package:finalproject/features/auth/domain/entity/auth_entity.dart';
import 'package:finalproject/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUseCaseProvider = Provider((ref) {
  return AuthUseCase(ref.read(authRepositoryProvider));
});

class AuthUseCase {
  final IAuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<Either<Failure, bool>> registerStudent(AuthEntity student) async {
    return await _authRepository.registerStudent(student);
  }

  Future<Either<Failure, bool>> loginStudent(String? username, String? password) async {
    return await _authRepository.loginStudent(username ?? "", password ?? "");
  }

  // Future<Either<Failure, AuthEntity>> getCurrentUser() async {
  //   return await _authRepository.getCurrentUser();
  // }
}
