import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // TOP SECTION (BRANDING)
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 24, bottom: 30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "KrustyKonnect",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // FORM SECTION
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Login to your account",
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 30),

                  // EMAIL
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DIVIDER
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR"),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // GOOGLE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text("Continue with Google"),
                    ),
                  ),

                  const Spacer(),

                  // SIGN UP
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Don’t have an account? Sign up"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}