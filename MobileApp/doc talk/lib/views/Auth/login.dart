import 'package:doc_talk/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/AuthController.dart';
import '../shared/utils.dart';
import 'SignUp.dart';

class LogInPage extends GetView {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    var width = Config.screenWidth;
    var height = Config.screenHeight;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: linearColor,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                  height: height! / 4,
                  child:
                      SvgPicture.asset("assets/undraw_secure_login_pdn4.svg")),
              SizedBox(
                height: height / 50,
              ),
              Center(
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust corner radius as desired
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    height: height * 0.55,
                    width: width! * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: linearColor,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: width,
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        height: 0.9),
                                  )),
                              Text("Glad to have your back",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: widgetColor)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const LoginForm(),
                        Container(
                            width: width,
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password ?",
                                  style: TextStyle(
                                      fontSize: 12, color: widgetColor),
                                ))),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Don’t have an account ?",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.off(SignUpPage());
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: widgetColor),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: width / 6,
                                child: const Divider(
                                  thickness: 1.5,
                                  color: Colors.black,
                                )),
                            const Text(
                              "  Or Sign in with  ",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                                width: width / 6,
                                child: const Divider(
                                  thickness: 1.5,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 40,
                                    height: 30,
                                    child:
                                        Image.asset("assets/googlelogo.png")),
                                const Text(
                                  "Sign in with Gmail",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late AuthController _authController;
  String _email = "";
  String _password = "";
  bool _isHidden = true;
  void togelView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController = Get.put(AuthController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authController.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                labelText: "Email",
                // prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
              style: const TextStyle(height: 1.0),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 40,
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                labelText: "Password",
                // prefixIcon: const Icon(Icons.lock),
                // Add an icon to toggle password visibility (optional)
                suffixIcon: IconButton(
                  icon: Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                ),
              ),
              obscureText: _isHidden ? true : false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              onChanged: (value) {},
              onSaved: (value) {
                _password = value!;
              },
              style: const TextStyle(height: 1.0),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _authController.signIn(_email, _password);
                    Get.off(const HomePage());
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(widgetColor)),
                child: const Text(
                  "Log In",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
