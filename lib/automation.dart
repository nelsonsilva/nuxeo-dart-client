/**
 * Provides a Nuxeo Automation Client Library.
 *
 * ## Installing ##
 *
 * Use [pub][] to install this package. Add the following to your `pubspec.yaml`
 * file.
 *
 *     dependencies:
 *       nuxeo_automation: any
 *
 * Then run `pub install`.
 *
 * ## Quick Start ##
 *
 *
 * This library should not be imported directly.
 * You should use either `browser_client` or `standalone_client`
 * as these provide proper abstractions (see [http_client](http_client.html)).
 *
 * * For browser applications use:
 *
 *     `import 'package:nuxeo_automation/browser_client.dart' as nuxeo_automation;`
 *
 * * For standalone/console applications use:
 *
 *     `import 'package:nuxeo_automation/standalone_client.dart' as nuxeo_automation;`
 *
 * * Then create your [Client] instance:
 *
 *     `var nx = new nuxeo_automation.Client();`
 *
 *
 * For more information, see the
 * [nuxeo_automation package on pub.dartlang.org](http://pub.dartlang.org/packages/nuxeo_automation).
 *
 * [pub]: http://pub.dartlang.org
 */
library nuxeo_automation;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as Math;
import 'dart:json' as JSON;
import 'package:logging/logging.dart';
import 'http.dart' as http;

part 'src/request.dart';
part 'src/operation.dart';
part 'src/uploader.dart';
part 'src/registry.dart';
part 'src/document.dart';

/**
 * [Automation] client.
 */
abstract class Client {

  static final LOG = new Logger("nuxeo.automation");

  /// The [http.Client] to use
  http.Client _client;

  Uri _uri;

  Client(this._client, String url) {
    _uri = Uri.parse(url);
  }

  /// Creates an [OperationRequest] for the [Operation] with the given [id].
  ///
  /// You can also specify an [execTimeout] and an [uploadTimeout].
  OperationRequest op(String id, {
    execTimeout: const Duration(seconds: 30),
    uploadTimeout: const Duration(minutes: 20)
  }) => new OperationRequest._(id, _uri, _client,
      execTimeout: execTimeout,
      uploadTimeout: uploadTimeout);

  Future<OperationRegistry> get registry => OperationRegistry.get(_uri, _client);

}

/**
 * Exception thrown when an [OperationRequest] throws an error
 */
class AutomationException implements Exception {
  /**
   * A message describing the error.
   */
  final String message;

  /**
   * Creates a new AutomationException with an optional error [message].
   */
  const AutomationException([this.message = ""]);

  String toString() => "AutomationException: $message";
}