class User {
  final String userId;
  final String nom;
  final String prenom;
  final int age;
  final String tel;
  final String mail;
  final String gender;

  User(
      {required this.userId,
      required this.nom,
      required this.prenom,
      required this.age,
      required this.mail,
      required this.tel,
      required this.gender});
}
