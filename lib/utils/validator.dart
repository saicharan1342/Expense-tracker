class Appvalidator{

  String? validemail(value){
    if(value!.isEmpty){
      return 'Please Enter Email';
    }
    RegExp emailreg=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailreg.hasMatch(value)){
      return 'Enter valid Email';
    }
    return null;
  }
  String? phonevalid(value){
    if(value!.isEmpty){
      return 'Please Enter Phone number';
    }
    if(value.length!=10){
      return 'Enter 10 digits';
    }
    return null;
  }
  String? passvalid(value){
    if(value!.isEmpty){
      return 'Please Enter Password';
    }
    return null;
  }
  String? uservalid(value){
    if(value!.isEmpty){
      return 'Enter Username';
    }
    return null;
  }
  String? isEmptycheck(value){
    if(value!.isEmpty){
      return 'Please fill details';
    }
    return null;
  }
}