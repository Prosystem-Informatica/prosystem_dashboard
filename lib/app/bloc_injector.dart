import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prosystem_dashboard/app/app_widget.dart';
import 'package:prosystem_dashboard/app/core/helpers/environments.dart';
import 'package:prosystem_dashboard/app/core/rest/http/http_rest_client.dart';
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/daily_payments/cubit/daily_payments_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/cubit/month_payments_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/technical_assistance/cubit/technical_assistance_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/repositories/commercial/commercial_repository.dart';
import 'package:prosystem_dashboard/app/repositories/daily_payments/daily_payments_repository.dart';
import 'package:prosystem_dashboard/app/repositories/financial/financial_repository.dart';
import 'package:prosystem_dashboard/app/repositories/login/login_repository.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/month_payments_repository.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/payment_daily_repository.dart';
import 'package:prosystem_dashboard/app/repositories/register/register_repository.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/technical_assistance_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/home/modules/comercial/cubit/commercial_bloc_cubit.dart';
import 'modules/home/modules/financial/cubit/financial_bloc_cubit.dart';
import 'modules/home/modules/register/cubit/register_bloc_cubit.dart';

class BlocInjection extends StatelessWidget {
  final RestClient _apiRestClient =
      HttpRestClient(baseUrl: Environments.get('BASE_URL') ?? "");
  late SharedPreferences prefs;

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
      BlocProvider<RegisterCubit>(
        create: (_) => RegisterCubit(
            registerRepository: RegisterRepository(rest: _apiRestClient)),
      ),
      BlocProvider<DailyPaymentsCubit>(
        create: (_) => DailyPaymentsCubit(
            dailyPaymentsRepository:
                DailyPaymentsRepository(rest: _apiRestClient)),
      ),
      BlocProvider<TechnicalAssistanceBlocCubit>(
        create: (_) => TechnicalAssistanceBlocCubit(
            technicalAssistanceRepository:
                TechnicalAssistanceRepository(rest: _apiRestClient)),
      ),
      BlocProvider<MonthPaymentsBlocCubit>(
        create: (_) => MonthPaymentsBlocCubit(
            monthPaymentsRepository:
                MonthPaymentsRepository(rest: _apiRestClient)),
      ),
      BlocProvider<FinancialBlocCubit>(
        create: (_) => FinancialBlocCubit(
            financialRepository: FinancialRepository(rest: _apiRestClient)),
      ),
      BlocProvider<CommercialBlocCubit>(
        create: (_) => CommercialBlocCubit(
            commercialRepository: CommercialRepository(rest: _apiRestClient)),
      ),
    ], child: const AppWidget());
  }
}
