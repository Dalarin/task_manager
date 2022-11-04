import 'dart:convert';

import 'package:http/http.dart';

import '../../models/invite.dart';
import '../../providers/constants.dart';

class InviteProvider {
  Future<List<Invite>?> fetchInvitationsByUserId(int userId) async {
    Response response = await get(Uri.parse('$apiURI/invite?userId=$userId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((invite) => Invite.fromJson(invite)).toList();
    }
    return null;
  }


}