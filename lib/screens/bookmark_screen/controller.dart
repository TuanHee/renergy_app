import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/bookmark.dart';
import 'package:renergy_app/common/services/api_service.dart';

class BookmarkController extends GetxController {
  List<Bookmark> bookmarks = [];

  Future<void> fetchBookmark() async {
    try{
      final res = await Api().get(Endpoints.bookmarkIndex);

    if (res.data['status'] != 200) {
      throw ('Failed to fetch Bookmark: ${res.data['message'] ?? 'Unknown error'}');
    }

    if (res.data['data']['bookmarks'] is! List) {
      throw ('Failed to fetch Bookmark: bookmarks is not a list');
    }

    bookmarks = (res.data['data']['bookmarks'] as List)
        .map((element) => Bookmark.fromJson(element))
        .toList();

    print(bookmarks.length);
    }
    catch(e){
      rethrow;
    }
    
  }

  Future<void> removeBookmark(int? bookmarkId) async {
    if (bookmarkId == null) {
      throw 'Failed to remove bookmark: Try it Later';
    }
    final removed = bookmarks.firstWhereOrNull((e) => e.id == bookmarkId);

    if (removed == null) {
      throw 'Failed to remove bookmark: do not have this bookmark';
    }
    bookmarks.remove(removed);
    update();

    try {
      final res = await Api().delete(Endpoints.deleteBookmark(bookmarkId));

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to remove bookmark';
      }
    } catch (e) {
      bookmarks.add(removed);
      update();
      rethrow;
    }
  }
}