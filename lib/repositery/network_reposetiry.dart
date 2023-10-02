import "dart:convert";

import "package:http/http.dart" as http;
import "package:note_app_mongo_db/models/NoteModel.dart";
import "package:note_app_mongo_db/models/UserModel.dart";

class ServerException implements Exception {
  final String errorMag;

  ServerException(this.errorMag);
}

class NetworkRepository {
  final http.Client httpClient = http.Client();

  String endPoint(String EndPoint) {
    return "http://192.168.10.10:5000/v1/${EndPoint}";
  }

  Map<String, String> header = {
    "Content-Type": "application/json; charset=utf-8",
  };

  Future<UserModel> singUp(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.post(Uri.parse(endPoint("user/signup")),
        body: encodedParams, headers: header);
    print("Server Response: ${response.body}");

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["response"]);
    }
  }

  Future<UserModel> singIn(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.post(Uri.parse(endPoint("user/signIn")),
        body: encodedParams, headers: header);
    print("Server Response: ${response.body}");

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["response"]);
    }
  }

  Future<UserModel> myProfile(UserModel user) async {
    final response = await httpClient.get(
        Uri.parse(endPoint("user/myProfile?uid=${user.uid}")),
        headers: header);
    print("Server Response: ${response.body}");

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)["response"]);
      return userModel;
    } else {
      throw ServerException(json.decode(response.body)["response"]);
    }
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.put(
        Uri.parse(endPoint("user/updateProfile")),
        body: encodedParams,
        headers: header);

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)['response']);

      return userModel;
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<List<NoteModel>> getMyNotes(NoteModel note) async {
    final response = await httpClient.get(
        Uri.parse(endPoint("note/getMyNotes?uid=${note.creatorId}")),
        headers: header);

    if (response.statusCode == 200) {
      List<dynamic> notes = json.decode(response.body)['response'];

      final notesData = notes.map((item) => NoteModel.fromJson(item)).toList();

      return notesData;
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<String> addNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.post(Uri.parse(endPoint("note/addNote")),
        body: encodedParams, headers: header);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final noteId =
          responseBody['noteId']; // Assuming your server returns the noteId
      print(responseBody);
      return noteId; // Return the noteId
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<void> updateNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.put(
        Uri.parse(endPoint("note/updateNote")),
        body: encodedParams,
        headers: header);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    final encodedParams = json.encode(note.toJson());

    final response = await httpClient.delete(
        Uri.parse(endPoint("note/deleteNote")),
        body: encodedParams,
        headers: header);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }
}
