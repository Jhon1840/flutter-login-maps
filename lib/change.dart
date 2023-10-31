import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2018/08/04/20/48/woman-3584435_1280.jpg'))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Colors.orange),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", "Username", false),
              buildTextField("Birthday Date", "DY-MN-YR", false),
              buildTextField("Cell Phone Number", "00000000", false),
              buildTextField("Email", "username@gmail.com", false),
              buildTextField("Password", "**********", false),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* OutlinedButton(
                    onPressed: () {}, 
                    child: Text("CANCEL", style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.black
                    )),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),*/
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("SAVE",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 153, 0),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelTex, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {})
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelTex,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
