library nuxeo_http;

import 'dart:async';
import 'dart:utf';

const HEADER_CONTENT_TYPE = "content-type";

class MultipartFormData {
  Map<String, dynamic> data = {};
  append(String name, value) {
    data[name] = value;
  }
}

class Blob {
  String filename;
  List<int> content;
  String mimetype;

  Blob({this.filename: "blob", content, this.mimetype}) {
    if (content is String) {
      this.content = encodeUtf8(content);
    } else if (content is List<int>) {
      this.content = content;
    }
  }

  int get length => content.length;
}

abstract class Response {
  get body;
}

abstract class RequestHeaders {
  set(String name, String value);
}

abstract class RequestUpload {
}

class RequestEvent {
  String type;
  RequestEvent(this.type);
}

abstract class Request {
  RequestHeaders get headers;
  get upload;
  Future<Response> send([data]);
}

abstract class Client {
  Request get(Uri uri);
  Request post(Uri uri, {bool multipart:false});
}