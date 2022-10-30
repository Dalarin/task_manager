import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/register_bloc/register_bloc.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/repository/user_repository.dart';
import '../elements/navigation_bar.dart' as element;

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(UserRepository()),
          child: BlocListener<RegisterBloc, RegisterState>(
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state is RegisterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return RegisterInputForm(context: context);
                }
              },
            ),
            listener: (context, state) {
              if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  _buildSnackBar(state.message, context),
                );
              } else if (state is RegisterLoaded) {
                user = state.user;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const element.NavigationBar(),
                  ),
                );
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

class RegisterInputForm extends StatefulWidget {
  final BuildContext context;

  const RegisterInputForm({Key? key, required this.context}) : super(key: key);

  @override
  State<RegisterInputForm> createState() => _RegisterInputFormState();
}

class _RegisterInputFormState extends State<RegisterInputForm> {
  late double width;
  late double height;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController fioController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    fioController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(child: _inputWidget(context));
  }

  Widget _inputWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
      child: _topContainer(context),
    );
  }

  Widget _textInput(
      {required TextEditingController controller,
      required Icon icon,
      required String label,
      required bool isPassword}) {
    return TextField(
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: icon,
      ),
    );
  }

  Widget _topContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Регистрация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15),
        const Text('Пожалуйста, заполните данные для регистрации'),
        const SizedBox(height: 30),
        _textInput(
            controller: emailController,
            icon: const Icon(Icons.email),
            label: 'Email',
            isPassword: false),
        const SizedBox(height: 20),
        _textInput(
            controller: phoneController,
            icon: const Icon(Icons.phone),
            label: 'Номер телефона',
            isPassword: false),
        const SizedBox(height: 20),
        _textInput(
            controller: fioController,
            icon: const Icon(Icons.person),
            label: 'ФИО',
            isPassword: false),
        const SizedBox(height: 20),
        _textInput(
          controller: passwordController,
          icon: const Icon(Icons.key),
          label: 'Пароль',
          isPassword: true,
        ),
        const SizedBox(height: 30),
        _signInButton(context),
      ],
    );
  }

  Widget _signInButton(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<RegisterBloc>(context).add(
          RegisterStarted(
            emailController.text,
            phoneController.text,
            passwordController.text,
            fioController.text,
          ),
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
          'Зарегистрироваться',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
