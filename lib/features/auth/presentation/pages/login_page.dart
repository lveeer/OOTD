import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/mock/mock_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../blocs/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _canSendSms = true;
  int _countdown = 60;
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _canSendSms = false;
      _countdown = 60;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _countdown--;
      });
      
      if (_countdown <= 0) {
        setState(() {
          _canSendSms = true;
        });
        return false;
      }
      return true;
    });
  }

  void _sendSmsCode() {
    final phone = _phoneController.text.trim();
    if (phone.length != 11) {
      setState(() {
        _phoneError = '请输入正确的手机号';
      });
      return;
    }
    
    setState(() {
      _phoneError = null;
    });
    
    context.read<AuthBloc>().add(SendSmsCodeRequested(phone: phone));
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(LoginRequested(
        phone: _phoneController.text.trim(),
        smsCode: _smsCodeController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SmsCodeSent) {
              _startCountdown();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('验证码已发送')),
              );
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Icon(
                      PhosphorIcons.tShirt(),
                      size: 80,
                      color: AppColors.accent, // 黑色
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '今日穿搭',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXXL,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '分享穿搭，发现好物',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeM,
                        color: AppColors.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: InputDecoration(
                        labelText: '手机号',
                        hintText: '请输入手机号',
                        prefixIcon: Icon(PhosphorIcons.phone()),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入手机号';
                        }
                        if (value.length != 11) {
                          return '请输入正确的手机号';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _smsCodeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              labelText: '验证码',
                              hintText: '请输入验证码',
                              prefixIcon: Icon(PhosphorIcons.shieldCheck()),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入验证码';
                              }
                              if (value.length != 6) {
                                return '请输入6位验证码';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        AppButton(
                          text: _canSendSms ? '获取验证码' : '${_countdown}s',
                          onPressed: _canSendSms ? _sendSmsCode : null,
                          type: AppButtonType.outline,
                          width: 120,
                          isLoading: state is SmsCodeSending,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    AppButton(
                      text: '登录',
                      onPressed: _login,
                      type: AppButtonType.primary,
                      isLoading: state is AuthLoading,
                      isFullWidth: true,
                    ),
                    if (MockConfig.enabled) ...[
                      const SizedBox(height: AppConstants.spacingM),
                      TextButton.icon(
                        onPressed: () {
                          _phoneController.text = MockConfig.testPhone;
                          _smsCodeController.text = MockConfig.testSmsCode;
                          setState(() {
                            _phoneError = null;
                          });
                        },
                        icon: Icon(
                          PhosphorIcons.magicWand(),
                          size: 16,
                        ),
                        label: const Text('使用测试账号'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.grey600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}