import 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/Login/login_screen.dart' show LoginScreen;
import 'package:fruity/Register/cubit/register_states.dart'
    show
        RegisterErrorState,
        RegisterLoadingState,
        RegisterStates,
        RegisterSuccessState;
import 'package:fruity/network/domain_layer/repos/auth_repo.dart' show AuthRepo;
import '../compoents/components.dart';
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isTermsChecked = false;
  void onChanged(bool? value) {
    setState(() {
      isTermsChecked = value ?? false;
    });
  }

  bool isPasswordConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(getIt<AuthRepo>()),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is RegisterSuccessState) {
            showToast(
              text: 'Account has been created',
              state: ToastStates.SUCCESS,
            );
            navigateAndFinish(context, const LoginScreen());
          }
        },
        builder:
            (context, state) => Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),
                          Image.asset(
                            'assets/icons/app_icon.png',
                            width: 100,
                            height: 100,
                          ),

                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Name Field
                          buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          buildTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
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
                          const SizedBox(height: 20),

                          // Password Field
                          buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                );
                              },
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
                          const SizedBox(height: 20),

                          // Confirm Password Field
                          buildTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            icon: Icons.lock,
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                setState(
                                  () =>
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible,
                                );
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Checkbox(
                                value: isTermsChecked,
                                onChanged:
                                    onChanged, // Passes `bool?` instead of `bool`
                                activeColor: Colors.blue,
                              ),

                              const Text(
                                'By signing up, you agree to our ',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle Terms of Service tap
                                },
                                child: const Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                ' and ',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle Privacy Policy tap
                                },
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ConditionalBuilder(
                              condition: state is! RegisterLoadingState,
                              builder:
                                  (context) => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                    onPressed: () async {
                                      if (!isTermsChecked) {
                                        showToast(
                                          text:
                                              'You must agree to the Terms of Service and Privacy Policy',
                                          state: ToastStates.ERROR,
                                        );
                                        return;
                                      }

                                      // Check internet connection
                                      var connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();
                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        showToast(
                                          text:
                                              'You are offline. Please check your connection and try again.',
                                          state: ToastStates.ERROR,
                                        );
                                        return;
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        RegisterCubit.get(
                                          context,
                                        ).createUserWithEmailAndPassword(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              fallback:
                                  (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            ),
                          ),
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, const LoginScreen());
                                },
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Divider
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );
  }
}
