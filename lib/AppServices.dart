
import 'package:treehacks_2019_whiteboard/services/FirebaseMessageService.dart';
import 'package:treehacks_2019_whiteboard/services/MessageService.dart';
import 'package:treehacks_2019_whiteboard/services/WhiteboardFirebase.dart';

class AppServices {

  static WhiteboardFirebase _whiteboardFirebase;
  static MessageService _messageService;

  static Future<bool> init() async{
    //todo: init firebase and rest of stuff
    _whiteboardFirebase = await WhiteboardFirebase.createInstance();
    _messageService = new FirebaseMessageService();
  }

  static MessageService getMessageService() => _messageService;

  static WhiteboardFirebase getFB() => _whiteboardFirebase;

}