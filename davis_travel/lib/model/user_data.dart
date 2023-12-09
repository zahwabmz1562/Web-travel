class UserData {
  String? userId;
  String? email;
  String? displayName;
  String? photoUrl;
  String? mobileNumber;
  String? gender;
  String? idCardNumber;
  String? citizenship;
  String? passportNumber;
  String? streetAddress;
  String? issuingCountry;

  UserData(
      {this.userId,
      this.email,
      this.displayName,
      this.photoUrl,
      this.mobileNumber,
      this.gender,
      this.idCardNumber,
      this.citizenship,
      this.passportNumber,
      this.streetAddress,
      this.issuingCountry});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    displayName = json['display_name'];
    photoUrl = json['photo_url'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    idCardNumber = json['id_card_number'];
    citizenship = json['citizenship'];
    passportNumber = json['passport_number'];
    streetAddress = json['street_address'];
    issuingCountry = json['issuing_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['display_name'] = displayName;
    data['photo_url'] = photoUrl;
    data['mobile_number'] = mobileNumber;
    data['gender'] = gender;
    data['id_card_number'] = idCardNumber;
    data['citizenship'] = citizenship;
    data['passport_number'] = passportNumber;
    data['street_address'] = streetAddress;
    data['issuing_country'] = issuingCountry;
    return data;
  }
}
