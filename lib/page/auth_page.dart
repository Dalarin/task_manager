import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/page/register_page.dart';
import 'package:task_manager/repository/user_repository.dart';
import '../elements/navigation_bar.dart' as element;

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(UserRepository())..add(AppStarted()),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  _buildSnackBar(state.message, context),
                );
              } else if (state is AuthLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const element.NavigationBar(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppStarting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return LoginInputForm(context: context);
              }
            },
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnackBar(String message, BuildContext context) {
    return SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LoginInputForm extends StatefulWidget {
  final BuildContext context;

  const LoginInputForm({Key? key, required this.context}) : super(key: key);

  @override
  State<LoginInputForm> createState() => _LoginInputFormState();
}

class _LoginInputFormState extends State<LoginInputForm> {
  late double width;
  late double height;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return _inputWidget(widget.context);
  }

  Widget _inputWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(child: _topContainer(context)),
          _bottomContainer(context),
        ],
      ),
    );
  }

  Widget _textInput(
      {required TextEditingController controller,
      required Icon icon,
      required String label,
      required bool isPassword}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: icon,
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<AuthBloc>(context).add(
          LoginEvent(emailController.text, passwordController.text),
        );
      },
      child: Container(
        height: height * 0.08,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF3B378E),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Text(
          'Авторизоваться',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _bottomContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Еще нет аккаунта?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            'Зарегистрироваться',
            style: TextStyle(
              color: Color(0xFF3B378E),
            ),
          ),
        )
      ],
    );
  }

  Widget _topContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Авторизация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15),
        const Text('Пожалуйста, заполните данные для входа'),
        const SizedBox(height: 25),
        _textInput(
            controller: emailController,
            icon: const Icon(Icons.email),
            label: 'Email',
            isPassword: false),
        const SizedBox(height: 25),
        _textInput(
          controller: passwordController,
          icon: const Icon(Icons.key),
          isPassword: true,
          label: 'Пароль',
        ),
        const SizedBox(height: 25),
        _signInButton(context)
      ],
    );
  }
}
