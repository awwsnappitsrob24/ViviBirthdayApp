import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivi_bday_app/Setup/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// User ID class that will be passed to the login page and also passed to homepage
class UserID {
  int ID;

  UserID({this.ID});
}

class _RegisterPageState extends State<RegisterPage> {
  String _firstName, _lastName, _email, _password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  final databaseReference = Firestore.instance;

  int userUniqueID;

   @override
  Widget build(BuildContext context) {
    
    /// First Name TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - White text and hint text
    final firstNameField = TextFormField(
      validator: (input) {
        if(input.isEmpty) {
          return 'First name cannot be empty.'; // empty check
        }
      },
      onSaved: (input) => _firstName = input, // save user input into variable for authentication
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        filled: true,
        prefixIcon: Icon(Icons.person_add, color: Colors.pink[100]),
        hintText: "First Name",
        hintStyle: TextStyle(color: Colors.white),
    ));


    /// Last Name TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - White text and hint text
    final lastNameField = TextFormField(
      validator: (input) {
        if(input.isEmpty) {
          return 'Last name cannot be empty.'; // empty check
        }
      },
      onSaved: (input) => _lastName = input, // save user input into variable for authentication
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        filled: true,
        prefixIcon: Icon(Icons.person_add, color: Colors.pink[100]),
        hintText: "Last Name",
        hintStyle: TextStyle(color: Colors.white),
    ));


    /// Email TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - White text and hint text
    final emailField = TextFormField(
      validator: (input) {
        if(input.isEmpty) {
          return 'Email cannot be empty.'; // empty check
        }
      },
      onSaved: (input) => _email = input, // save user input into variable for authentication
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        filled: true,
        prefixIcon: Icon(Icons.email, color: Colors.pink[100]),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
    ));
    

    /// Password TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - White text and hint text
    final passwordField = TextFormField(
      validator: (input) {
        if(input.isEmpty) {
          return 'Password cannot be empty.'; // empty check
        }
      },
      onSaved: (input) => _password = input, // save user input into variable for authentication
      style: style,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.pink[100]),
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white),
    ));
  
    
    /// Register Button
    /// - Filled in blue
    /// - White text
    /// - Triggers "register" function when tapped
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        // trigger register function here
        onPressed: register,

        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: ModalProgressHUD(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bgimg.jpg"), // background image to fit whole page
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Center (           
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(height: 10.0), // use these sizedboxes to represent spaces between widgets
                    firstNameField, // first name textfield that was built earlier

                    SizedBox(height: 10.0),
                    lastNameField, // password textfield that was built earlier

                    SizedBox(height: 10.0),
                    emailField, // email textfield that was built earlier

                    SizedBox(height: 10.0),
                    passwordField, // password textfield that was built earlier

                    SizedBox(
                      height: 90.0,
                    ),
                    registerButton, // register button that was built earlier

                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      inAsyncCall: _isLoading),
    );
  }

  /// Login function to authenticate users using Firebase
  Future<void> register() async {

    // Validate fields
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // When user presses login button, show Modal Progress HUD
        setState(() {
          _isLoading = true;
        });

        // Create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword
          (email: _email, password: _password);

        // Store user's data in firestore for later retrieval
        var rng = new Random();
        userUniqueID = rng.nextInt(1000000000);
        DocumentReference ref = await Firestore.instance.collection("users")
        .add({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'password': _password,
          'uniqueID' : userUniqueID,
        });
        

        // After authenticating, hide Modal Progress HUD
        setState(() {
          _isLoading = false;
        });

        // If register is successful, go to login passing along the user's ID
        final userID = UserID(
          ID: userUniqueID,
        );

        // If register is successful, go back to login so user can log in
        Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginPage(userID: userID)));

        // Successful message in a toast
        Fluttertoast.showToast(
          msg: "User created!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } catch(e) {
        
        // Hide Modal Progress HUD
        setState(() {
          _isLoading = false;
        });

        // Error message in a toast
        Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    }
  }
}