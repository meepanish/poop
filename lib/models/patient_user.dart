class PatientModel {
  final String?  id;
  final String email;
  final String fullName;
  final String password;
  
  

  const PatientModel({
    this.id,
    required this.email,
    required this.fullName,
    required this.password,

  });

  toJson() {
    return {
      'Name' : fullName,
      'Email' : email,
      'Password' : password,
    };
  }
  
}