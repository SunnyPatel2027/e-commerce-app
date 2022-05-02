// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    required this.title,
    required this.isbn,
    required this.pageCount,
    required this.publishedDate,
    required this.thumbnailUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.status,
    required this.authors,
    required this.categories,
    required this.MRP,
    required this.price,
  });

  String title;
  String isbn;
  int pageCount;
  String publishedDate;
  String? thumbnailUrl;
  String? shortDescription;
  String? longDescription;
  String status;
  List<String> authors;
  List<String> categories;
  String MRP;
  String price;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        title: json["title"],
        isbn: json["isbn"] == null ? null : json["isbn"],
        pageCount: json["pageCount"],
        publishedDate: json["publishedDate"],
        thumbnailUrl:
            json["thumbnailUrl"] == null ? null : json["thumbnailUrl"],
        shortDescription: json["shortDescription"] == null ? null : json["shortDescription"],
        longDescription:
            json["longDescription"] == null ? null : json["longDescription"],
        status: json["status"],
        authors: List<String>.from(json["authors"].map((x) => x)),
        categories: List<String>.from(json["categories"].map((x) => x)),
        MRP: json['MRP'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "isbn": isbn == null ? null : isbn,
        "pageCount": pageCount,
        "publishedDate": publishedDate == null ? null : publishedDate,
        "thumbnailUrl": thumbnailUrl == null ? null : thumbnailUrl,
        "shortDescription": shortDescription == null ? null : shortDescription,
        "longDescription": longDescription == null ? null : longDescription,
        "status": status,
        "authors": List<dynamic>.from(authors.map((x) => x)),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "MRP" : MRP,
        "price" : price
      };
}

class PublishedDate {
  PublishedDate({
    required this.date,
  });

  String date;

  factory PublishedDate.fromJson(Map<String, dynamic> json) => PublishedDate(
        date: json["\u0024date"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024date": date,
      };
}

// enum Status { PUBLISH, MEAP }

// final statusValues = EnumValues({
//   "MEAP": Status.MEAP,
//   "PUBLISH": Status.PUBLISH
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//    EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
