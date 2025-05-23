

evalEmail(value) {
  RegExp regex =  RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.length == 0) { 
    return "email is required";
  } else if (!regex.hasMatch(value)){

    return 'please enter valid email';
  }
  else{
    return null;

  }
}
evalPassword(value) {
  RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value.length == 0) {
    return "password is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter 8 character alphanumeric password';
  }
    
  else{
    return null;

  }
}
// evalConfirmPass(value) {

//   if (value.length == 0) {
//     return "password is Required";
//   }
//    else if (value != model.password) {
//                         return 'Passwords do not match';
//                       }
    
//   else{
//     return null;

//   }
// }
evalPhone(value) {
  RegExp regex = RegExp(r'^(?=.*?[0-9]).{10}$');
  if (value.length == 0) {
    return "Phone no. is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter 10 Digit';
  }
    
  else{
    return null;

  }
}
evalFirst(value) {
  RegExp regex = RegExp(r'^(?=.*?[a-z]).{5,}$');
  if (value.length == 0) {
    return "First name is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter atleast 5 character';
  }
    
  else{
    return null;

  }
}
evalLast(value) {
  RegExp regex = RegExp(r'^(?=.*?[a-z]).{5,}$');
  if (value.length == 0) {
    return "Last name is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter atleast 5 character';
  }
    
  else{
    return null;

  }
}

evalPincode(value){
   RegExp regex = RegExp(r'^(?=.*?[0-9]).{6}$');
  if (value.length == 0) {
    return "Phone is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter 6 Digit';
  }
    
  else{
    return null;

  }

}
String? emptyFieldValidator(String? value, String label) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required';
  }
  return null;
}
