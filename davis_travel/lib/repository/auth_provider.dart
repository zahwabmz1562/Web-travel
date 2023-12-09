import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:davis_travel/model/city.dart';
import 'package:davis_travel/model/transportation.dart';
import 'package:davis_travel/model/user_data.dart';
import 'package:davis_travel/utils/shared_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

class AuthProvider {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "778048144943-p2vr7vbh8bmpnka70k7ubiapmsgdmff4.apps.googleusercontent.com",
      scopes: []);

  static Widget buildSignInButton() {
    return (GoogleSignInPlatform.instance as web.GoogleSignInPlugin)
        .renderButton();
  }

  static Future<UserData?> getProfile() async {
    String? userId = await getSharedString("user_id");

    if (userId != null) {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      if (querySnapshot.docs.any((e) => e.id == userId)) {
        UserData result = UserData.fromJson(querySnapshot.docs
            .firstWhere((e) => e.id == userId)
            .data() as Map<String, dynamic>);

        return result;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> addUser(UserData user) async {
    try {
      final querySnapshot = _firestore.collection('users');

      await querySnapshot.add({
        "userId": user.userId,
        "email": user.email,
        "display_name": user.displayName,
        "photo_url": user.photoUrl,
        "mobile_number": user.mobileNumber,
        "gender": user.gender,
        "id_card_number": user.idCardNumber,
        "citizenship": user.citizenship,
        "passport_number": user.passportNumber,
        "street_address": user.streetAddress,
        "issuing_country": user.issuingCountry
      });

      return true;
    } catch (e) {
      print("Error reading addUser: $e");
      return false;
    }
  }

  static Future<bool> updateUser(UserData user) async {
    try {
      final querySnapshot = _firestore.collection('users');

      await querySnapshot.doc(user.userId).update({
        "userId": user.userId,
        "email": user.email,
        "display_name": user.displayName,
        "photo_url": user.photoUrl,
        "mobile_number": user.mobileNumber,
        "gender": user.gender,
        "id_card_number": user.idCardNumber,
        "citizenship": user.citizenship,
        "passport_number": user.passportNumber,
        "street_address": user.streetAddress,
        "issuing_country": user.issuingCountry
      });

      return true;
    } catch (e) {
      print("Error reading updateUser: $e");
      return false;
    }
  }

  static Future<Stream<User?>?> profile() async {
    try {
      if (kIsWeb) {
        await auth.setPersistence(Persistence.NONE);
      }

      return auth.authStateChanges();
    } on FirebaseAuthException catch (e) {
      print("Error reading profile: $e");
      return null;
    }
  }

  static Future<Stream<GoogleSignInAccount?>?> profileGoogle() async {
    try {
      return googleSignIn.onCurrentUserChanged;
    } on FirebaseAuthException catch (e) {
      print("Error reading profileGoogle: $e");
      return null;
    }
  }

  static Future<void> reload() async {
    try {
      await auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      print("Error reading reload: $e");
    }
  }

  static Future<String?> login(
      {required String email, required String password}) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (response.user != null) {
        await setSharedString("user_id", response.user?.uid ?? "");
        await setSharedString("email", email);
        await setSharedString("passoword", password);
      }

      return response.user?.displayName ?? response.user?.email;
    } on FirebaseAuthException catch (e) {
      print("Error reading login: $e");
      return e.message ?? "Internal Server Error";
    }
  }

  static Future<String?> register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    try {
      final response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (response.user != null) {
        await auth.currentUser?.updateDisplayName("$firstName $lastName");
        await setSharedString("user_id", response.user?.uid ?? "");
        await setSharedString("email", email);
        await setSharedString("passoword", password);
      }

      return "$firstName $lastName";
    } on FirebaseAuthException catch (e) {
      print("Error reading register: $e");
      return e.message ?? "Internal Server Error";
    }
  }

  static Future<bool> logout() async {
    try {
      await removeShared("user_id");
      await removeShared("email");
      await removeShared("passoword");

      await auth.signOut();

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error reading logout: $e");
      return false;
    }
  }

  static Future<String?> autoLogin() async {
    try {
      String? email = await getSharedString("email");
      String? password = await getSharedString("passoword");

      if (email != null && password != null) {
        final response = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (response.user != null) {
          await setSharedString("user_id", response.user?.uid ?? "");
        }

        return response.user?.displayName ?? response.user?.email;
      } else {
        return "No user";
      }
    } on FirebaseAuthException catch (e) {
      print("Error reading autoLogin: $e");
      return e.message ?? "Internal Server Error";
    }
  }

  static Future<UserData?> autoLoginGoogle(
      GoogleSignInAuthentication googleAuth) async {
    try {
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final response = await auth.signInWithCredential(googleCredential);

      if (response.user != null) {
        await setSharedString("user_id", response.user?.uid ?? "");
        await setSharedBool("sign_google", true);
      }

      return await getProfile();
    } on FirebaseAuthException catch (e) {
      print("Error reading autoLoginGoogle: $e");
      return null;
    }
  }

  static Future<String?> googleLoginSilent() async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently();

      print(googleUser);

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final response = await auth.signInWithCredential(googleCredential);

        if (response.user != null) {
          await setSharedString("user_id", response.user?.uid ?? "");
          await setSharedBool("sign_google", true);
        }

        return response.user?.displayName ?? response.user?.email;
      } else {
        return "Google User Not Found";
      }
    } on FirebaseAuthException catch (e) {
      print("Error reading googleLoginSilent: $e");
      return e.message ?? "Internal Server Error";
    }
  }

  static Future<String?> googleLogin() async {
    try {
      GoogleSignInAccount? googleUser;

      try {
        googleUser = await googleSignIn.signIn();
        print("Google User:$googleUser");
      } catch (e) {
        print("Google User:$googleUser");
      }

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final response = await auth.signInWithCredential(googleCredential);

        if (response.user != null) {
          await setSharedString("user_id", response.user?.uid ?? "");
          await setSharedBool("sign_google", true);
        }

        return response.user?.displayName ?? response.user?.email;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("Error reading googleLogin: $e");
      return e.message ?? "Internal Server Error";
    }
  }

  static Future<bool> googleLogout() async {
    try {
      await removeShared("user_id");
      await removeShared("email");
      await removeShared("passoword");
      await removeShared("sign_google");

      await googleSignIn.signOut();

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error reading documents: $e");
      return false;
    }
  }

  static Future<List<Transportation>> getTransaport() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('transportation').get();

      List<Transportation> result = List.from(querySnapshot.docs.map(
          (e) => Transportation.fromJson(e.data() as Map<String, dynamic>)));

      return result;
    } catch (e) {
      print("Error reading documents: $e");
      return [];
    }
  }

  static Future<List<Transportation>> getHotel() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('hotel').get();

      List<Transportation> result = List.from(querySnapshot.docs.map(
          (e) => Transportation.fromJson(e.data() as Map<String, dynamic>)));

      return result;
    } catch (e) {
      print("Error reading documents: $e");
      return [];
    }
  }

  static Future<bool> addHotel({String? name, String? description}) async {
    try {
      final data = {
        "id": const Uuid().v4(),
        "name": name,
        "description": description,
        "image": "",
      };

      await _firestore.collection('hotel').add(data);

      return true;
    } catch (e) {
      print("Error reading documents: $e");
      return false;
    }
  }

  static Future<bool> addTrans({Transportation? trans}) async {
    try {
      final data = {
        "id": const Uuid().v4(),
        "name": trans?.name,
        "description": trans?.description,
        "image": "",
        "type": "train"
      };

      await _firestore.collection('transportation').add(data);

      return true;
    } catch (e) {
      print("Error reading documents: $e");
      return false;
    }
  }

  static Future<List<City>> getCity() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('city').get();

      List<City> result = List.from(querySnapshot.docs
          .map((e) => City.fromJson(e.data() as Map<String, dynamic>)));

      return result;
    } catch (e) {
      print("Error reading documents: $e");
      return [];
    }
  }

  static Future<bool> addCity({City? city}) async {
    try {
      final data = {
        "id": const Uuid().v4(),
        "price": city?.price ?? 0,
        "name": city?.name ?? "",
        "details": [
          for (Details detail in (city?.details ?? []))
            {
              "id": detail.id,
              "name": detail.name ?? "",
              "detail": detail.detail ?? ""
            },
        ],
        "benefit": city?.benefit ?? [],
        "description": city?.description ?? "",
        "label": city?.label ?? "",
        "image": ""
      };

      await _firestore.collection('city').add(data);

      return true;
    } catch (e) {
      print("Error reading documents: $e");
      return false;
    }
  }

  static Future<List<PrivateTrip>> getTrip() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('private_trip').get();

      List<PrivateTrip> result = List.from(querySnapshot.docs
          .map((e) => PrivateTrip.fromJson(e.data() as Map<String, dynamic>)));

      return result;
    } catch (e) {
      print("Error reading documents: $e");
      return [];
    }
  }
}
