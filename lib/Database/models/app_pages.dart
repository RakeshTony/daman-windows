import 'package:hive_flutter/adapters.dart';
import 'package:daman/DataBeans/DefaultConfigDataModel.dart';

part 'app_pages.g.dart';

@HiveType(typeId: 11)
class AppPages extends HiveObject {
  @HiveField(0)
  late String content;
  @HiveField(1)
  late String excerpt;
  @HiveField(2)
  late String slug;
  @HiveField(3)
  late String title;
}

extension AppPagesExtension on AppPages {
  AppPagesModel get toAppPagesModel => AppPagesModel()
    ..content = this.content
    ..excerpt = this.excerpt
    ..title = this.title
    ..slug = this.slug;
}

extension AppPagesModelExtension on AppPagesModel {
  AppPages get toAppPages => AppPages()
    ..content = this.content
    ..excerpt = this.excerpt
    ..title = this.title
    ..slug = this.slug;
}
