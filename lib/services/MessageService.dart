
import 'package:treehacks_2019_whiteboard/models/message.dart';

abstract class MessageService {
  /*
  api methods
   */

  Future<bool> postMessage(String content, String userId);

}