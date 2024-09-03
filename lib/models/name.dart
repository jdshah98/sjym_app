import '../utils/helper.dart';
import '../utils/keys.dart';
import 'entity.dart';

class Name extends Entity {
  String firstName;
  String middleName;
  String lastName;

  Name({this.firstName = '', this.middleName = '', this.lastName = ''});

  static Name fromMap(Map<String, dynamic>? map) {
    final Name name = Name();
    if (map != null) {
      name.firstName = Helper.getString(map, Keys.firstName);
      name.middleName = Helper.getString(map, Keys.middleName);
      name.lastName = Helper.getString(map, Keys.lastName);
    }
    return name;
  }

  @override
  Map<String, dynamic> toMap() => {
        Keys.firstName: firstName,
        Keys.middleName: middleName,
        Keys.lastName: lastName,
      };

  @override
  String toString() => '$firstName $middleName $lastName'.replaceAll(RegExp(r'\s+'), ' ').trim();
}
