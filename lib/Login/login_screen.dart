import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/Login/cubit/login_cubit.dart';
import 'package:fruity/Login/cubit/login_states.dart';
import '../Register/register_screen.dart';
import '../compoents/components.dart';
import '../layout/home_screen.dart';
import '../network/domain_layer/repos/auth_repo.dart';
import '../network/local/cache helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    final rememberedEmail =
        CacheHelper.getData(key: 'rememberedEmail') as String?;
    if (rememberedEmail != null) {
      setState(() {
        _emailController.text = rememberedEmail;
        _rememberMe = true;
      });
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ShopLoginCubit, ShopLoginStates>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Reset Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your email to receive a password reset link',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      state is ShopForgotPasswordLoadingState
                          ? null
                          : () async {
                            if (emailController.text.isEmpty) {
                              showToast(
                                text: 'Please enter your email',
                                state: ToastStates.ERROR,
                              );
                              return;
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(emailController.text)) {
                              showToast(
                                text: 'Please enter a valid email',
                                state: ToastStates.ERROR,
                              );
                              return;
                            }
                            await context
                                .read<ShopLoginCubit>()
                                .sendPasswordResetEmail(emailController.text);
                          },
                  child:
                      state is ShopForgotPasswordLoadingState
                          ? const CircularProgressIndicator()
                          : const Text('Send Reset Link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopLoginCubit>(
      create: (context) => ShopLoginCubit(getIt<AuthRepo>()),
      child: BlocListener<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            navigateAndFinish(context, const Home());
            showToast(text: 'Login Successful', state: ToastStates.SUCCESS);
          } else if (state is ShopLoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          } else if (state is ShopForgotPasswordSuccessState) {
            showToast(
              text: 'Password reset sent to ${state.email}',
              state: ToastStates.SUCCESS,
            );
            Navigator.pop(context);
          } else if (state is ShopForgotPasswordErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/icons/app_icon.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to continue shopping',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          cursorColor: const Color(0xFF1E88E5),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.blueGrey),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.blueGrey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: const Color(0xFF1E88E5),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.blueGrey),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.blueGrey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged:
                                        (value) => setState(() {
                                          _rememberMe = value ?? false;
                                        }),
                                    activeColor: const Color(0xFF1E88E5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const Flexible(child: Text('Remember me')),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => _showForgotPasswordDialog(context),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Color(0xFF1E88E5)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocBuilder<ShopLoginCubit, ShopLoginStates>(
                            builder: (context, state) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E88E5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed:
                                    state is ShopLoginLoadingState
                                        ? null
                                        : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final connectivityResult =
                                                await Connectivity()
                                                    .checkConnectivity();
                                            if (connectivityResult ==
                                                ConnectivityResult.none) {
                                              showToast(
                                                text: 'No internet connection',
                                                state: ToastStates.ERROR,
                                              );
                                              return;
                                            }
                                            context
                                                .read<ShopLoginCubit>()
                                                .userLogin(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                  rememberMe: _rememberMe,
                                                );
                                          }
                                        },
                                child:
                                    state is ShopLoginLoadingState
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                        : const Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // OR Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Social Login Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Google Login
                      OutlinedButton(
                        onPressed: () {
                          final cubit = BlocProvider.of<ShopLoginCubit>(
                            context,
                          );
                          cubit.signInWithGoogle();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDB4437),
                          side: const BorderSide(color: Color(0xFFDB4437)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(
                            0xFFDB4437,
                          ).withAlpha(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google_icon.png',
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDB4437),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Facebook Login
                      OutlinedButton(
                        onPressed:
                            () =>
                                context
                                    .read<ShopLoginCubit>()
                                    .signInWithFacebook(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4267B2),
                          side: const BorderSide(color: Color(0xFF4267B2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(
                            0xFF4267B2,
                          ).withAlpha(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/facebook_icon.png',
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Facebook',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4267B2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Apple Login
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.black.withAlpha(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/apple_icon.png',
                              width: 30,
                              height: 25,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Apple',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed:
                            () => navigateTo(context, const RegisterScreen()),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF1E88E5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
