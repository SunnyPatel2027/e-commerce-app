import 'package:e_commerce/modals/book.dart';
import 'package:get/get.dart';

class ListController extends GetxController{
  List<Book>? lists;
  Rx<List> searching = Rx<List>([]);
 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {}
  void searchBook(String value){
    List results = [];
    if(value.isEmpty){
      results= lists!;
    }else{
      results = lists!.where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList();
    }
    searching.value = results;
    }
}