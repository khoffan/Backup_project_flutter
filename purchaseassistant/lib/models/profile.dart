class Profiles {
  String? name;
  String? lName;
  String? phone;
  String? stdId;
  String? gender;
  String? room;
  String? dorm;
  String? image;

  Profiles(this.name, this.lName, this.dorm, this.gender, this.image, this.room,
      this.phone, this.stdId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'lname': lName,
      'dorm': dorm,
      'gender': gender,
      'image': image,
      'room': room,
      'phone': phone,
      'stdId': stdId
    };
  }

  // chaeck isemgty of profile data
  bool checkIsEmpty() {
    if (name == null &&
        lName == null &&
        dorm == null &&
        gender == null &&
        image == null &&
        room == null &&
        phone == null &&
        stdId == null) {
      return true;
    } else {
      return false;
    }
  }
}
