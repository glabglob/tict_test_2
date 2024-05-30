import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tict_test/blocks/user_data_cubit/user_data_state.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Map<String, dynamic>? _user;

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/user_cache.json';
  }

  Future<void> _writeToFile(String data) async {
    final path = await _getFilePath();
    final file = File(path);
    await file.writeAsString(data);
  }

  Future<String?> _readFromFile() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  bool _isValidDate(String input) {
    try {
      var formats = [
        DateFormat('yyyy-M-dd'),
        DateFormat('yyyy-M-d'),
        DateFormat('yyyy-MM-dd'),
        DateFormat('yyyy-MM-d'),
      ];

      for (var format in formats) {
        try {
          var date = format.parse(input);
          String formattedDate = format.format(date);
          if (formattedDate == input) {
            return true;
          }
        } catch (_) {}
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void _showMessage(BuildContext context, String messageText) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(messageText),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> loadCachedUser() async {
    print('Loading user from cache');
    String? cachedUser = await _readFromFile();

    if (cachedUser != null) {
      _user = jsonDecode(cachedUser);
      print('Cached user data: $_user');

      if (_user!.containsKey('birthDate')) {
        print('BirthDate: ${_user!['birthDate']}');
        emit(UserLoaded(_user!));
      } else {
        print('No birthDate key in cached user data');
        emit(UserError('No birthDate key in cached user data'));
      }
    } else {
      await fetchUser();
    }
  }

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      print('Fetching user from API...');
      var httpClient = HttpClient();
      var url = Uri.parse('https://dummyjson.com/users/1');
      var request = await httpClient.getUrl(url);
      var response = await request.close();

      if (response.statusCode == 200) {
        var responseBody = await response.transform(utf8.decoder).join();
        _user = jsonDecode(responseBody);
        print('Fetched user data: $_user');
        if (_user!.containsKey('birthDate')) {
          print('BirthDate: ${_user!['birthDate']}');
          if (_isValidDate(_user!['birthDate'])) {
            await _writeToFile(jsonEncode(_user));
            emit(UserLoaded(_user!));
          } else {
            print('Invalid date format in API response');
            emit(UserError('Invalid date format in API response'));
          }
        } else {
          print('No birthDate key in API response');
          emit(UserError('No birthDate key in API response'));
        }
      } else {
        print('Failed to load user from API: ${response.statusCode}');
        emit(UserError('Failed to load user from API: ${response.statusCode}'));
      }

      httpClient.close();
    } catch (e) {
      print('Error in fetchUser: $e');
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateBirthDate(String newDate, BuildContext context) async {
    DateTime parsedDate = DateTime.parse(newDate);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDateString = formatter.format(parsedDate);

    if (_isValidDate(formattedDateString)) {
      if (_user != null) {
        _user!['birthDate'] = newDate;
        emit(UserLoading());
        try {
          var httpClient = HttpClient();
          var url = Uri.parse('https://dummyjson.com/users/1');
          var request = await httpClient.putUrl(url);
          request.headers
              .set(HttpHeaders.contentTypeHeader, 'application/json');
          request.write(jsonEncode({'birthDate': newDate}));
          var response = await request.close();

          if (response.statusCode == 200) {
            var responseBody = await response.transform(utf8.decoder).join();
            _user = jsonDecode(responseBody);
            await _writeToFile(jsonEncode(_user));
            emit(UserLoaded(_user!));

            _showMessage(context, 'User updated');
          } else {
            _showMessage(context, 'Failed to update user');
            emit(UserError('Failed to update user: ${response.statusCode}'));
          }

          httpClient.close();
        } catch (e) {
          print('Error occurred: $e');
          emit(UserError(e.toString()));
        }
      }
    } else {
      emit(UserError('Invalid date format'));
      _showMessage(context, 'Invalid date format');
    }
  }
}
