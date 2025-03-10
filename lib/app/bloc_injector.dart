import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prosystem_dashboard/app/app_widget.dart';
import 'package:prosystem_dashboard/app/core/helpers/environments.dart';
import 'package:prosystem_dashboard/app/core/rest/http/http_rest_client.dart';
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/repositories/login/login_repository.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/payment_daily_repository.dart';

class BlocInjection extends StatelessWidget {
  final RestClient _apiRestClient =
      HttpRestClient(baseUrl: Environments.get('BASE_URL') ?? "");

  BlocInjection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBlocCubit>(
        create: (_) => LoginBlocCubit(
            loginRepository: LoginRepository(rest: _apiRestClient)),
      ),
      BlocProvider<PaymentDailyCubit>(
        create: (_) => PaymentDailyCubit(
            paymentDailyRepository: PaymentDailyRepository(rest: _apiRestClient)),
      ),
    ], child: const AppWidget());
  }
}
