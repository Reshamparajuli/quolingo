import 'dart:convert';

import 'package:finalproject/app/constants/shared_pref_constants.dart';
import 'package:finalproject/app/navigator/navigator.dart';
import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:finalproject/core/common/my_snackbar.dart';
import 'package:finalproject/features/auth/data/model/auth_api_model.dart';
import 'package:finalproject/features/auth/domain/entity/auth_entity.dart';
import 'package:finalproject/features/auth/domain/usecases/auth_usecase.dart';
import 'package:finalproject/features/auth/presentation/navigator/login_navigator.dart';
import 'package:finalproject/features/auth/presentation/state/auth_state.dart';
import 'package:finalproject/features/auth/presentation/view/register_view.dart';
import 'package:finalproject/features/home/presentation/navigator/home_navigator.dart';
import 'package:finalproject/features/home/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
      ref.read(loginViewNavigatorProvider), ref.read(authUseCaseProvider), ref.read(homeViewNavigatorProvider)),
);

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this.navigator, this.authUseCase, this.homeNavigator) : super(AuthState.initial());
  final AuthUseCase authUseCase;
  final LoginViewNavigator navigator;
  final HomeViewNavigator homeNavigator;

  Future<void> registerStudent(AuthEntity student) async {
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.registerStudent(student);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showMySnackBar(message: failure.error, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: "Successfully registered");
      },
    );
  }

  Future<void> loginStudent(
    String? username,
    String? password,
  ) async {
    if (username == null || password == null) {
      showMySnackBar(message: 'Username or Password cannot be null', color: Colors.red);
      return;
    }
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.loginStudent(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showMySnackBar(message: failure.error ?? 'Login failed', color: Colors.red);
      },
      (success) {
        // final authEntity = success;
        state = state.copyWith(isLoading: false, error: null);
        SharedPref.sharedPref.setString(Constants.userName, username);
        SharedPref.sharedPref.setBool(Constants.isUserLoggedIn, true);

        // SharedPref.sharedPref.setString(Constants.userEmail, authEntity.email);
        openHomeView();
      },
    );
  }

  void openRegisterView() {
    NavigateRoute.pushRoute(const RegisterView());
  }

  void openHomeView() {
    NavigateRoute.pushRoute(const HomeView());
  }
}
