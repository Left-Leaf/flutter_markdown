import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '_functions_io.dart';
import 'markdown_builder.dart';
import 'style_sheet.dart';

enum BulletStyle {
  orderedList,
  unorderedList,
}

enum MarkdownStyleSheetBaseTheme {
  /// Creates a MarkdownStyleSheet based on MaterialTheme.
  material,

  /// Creates a MarkdownStyleSheet based on CupertinoTheme.
  cupertino,

  /// Creates a MarkdownStyleSheet whose theme is based on the current platform.
  platform,
}

typedef MarkdownBulletBuilder = Widget Function(
    int index, BulletStyle style, int nestLevel);

typedef MarkdownTapLinkCallback = void Function(
    String text, String? href, String title);

typedef MarkdownImageBuilder = Widget Function(
    Uri uri, String? title, String? alt);

abstract class SyntaxHighlighter {
  InlineSpan format(String source);
}

abstract class MarkdownBuilderDelegate {
  BuildContext get context;

  GestureRecognizer createLink(String text, String? href, String title);

  InlineSpan formatText(MarkdownStyleSheet styleSheet, String code);
}

class MarkdownWidget extends StatefulWidget {
  final String data;
  final MarkdownStyleSheet styleSheet;
  final List<md.BlockSyntax>? blockSyntaxes;
  final List<md.InlineSyntax>? inlineSyntaxes;
  final md.ExtensionSet? extensionSet;
  final MarkdownBulletBuilder? bulletBuilder;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownImageBuilder? imageBuilder;
  final bool softLineBreak;
  final String? imageDirectory;
  final SyntaxHighlighter? syntaxHighlighter;
  final MarkdownStyleSheetBaseTheme? styleSheetTheme;

  const MarkdownWidget({
    super.key,
    required this.data,
    required this.styleSheet,
    this.onTapLink,
    this.blockSyntaxes,
    this.inlineSyntaxes,
    this.extensionSet,
    this.bulletBuilder,
    this.softLineBreak = false,
    this.imageBuilder,
    this.imageDirectory,
    this.syntaxHighlighter,
    this.styleSheetTheme,
  });

  @override
  State<StatefulWidget> createState() => _MarkdownWidgetState();

  Widget build(BuildContext context, List<Widget>? children) {
    if (children!.length == 1) {
      return children.single;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _MarkdownWidgetState extends State<MarkdownWidget>
    implements MarkdownBuilderDelegate {
  List<Widget>? _children;
  final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

  @override
  void didChangeDependencies() {
    _parseMarkdown();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MarkdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.styleSheet != oldWidget.styleSheet) {
      _parseMarkdown();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _parseMarkdown() {
    final MarkdownStyleSheet fallbackStyleSheet =
        kFallbackStyle(context, widget.styleSheetTheme);
    final MarkdownStyleSheet styleSheet =
        fallbackStyleSheet.merge(widget.styleSheet);

    _disposeRecognizers();

    final md.Document document = md.Document(
      blockSyntaxes: widget.blockSyntaxes,
      inlineSyntaxes: widget.inlineSyntaxes,
      extensionSet: widget.extensionSet ?? md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );
    final List<String> lines = const LineSplitter().convert(widget.data);
    final List<md.Node> astNodes = document.parseLines(lines);

    final MarkdownBuilder builder = MarkdownBuilder(
        delegate: this,
        styleSheet: styleSheet,
        bulletBuilder: widget.bulletBuilder,
        softLineBreak: widget.softLineBreak,
        imageBuilder: widget.imageBuilder,
        imageDirectory: widget.imageDirectory);

    _children = builder.build(astNodes);
  }

  void _disposeRecognizers() {
    if (_recognizers.isEmpty) {
      return;
    }
    final List<GestureRecognizer> localRecognizers =
        List<GestureRecognizer>.from(_recognizers);
    _recognizers.clear();
    for (final GestureRecognizer recognizer in localRecognizers) {
      recognizer.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _children);

  @override
  GestureRecognizer createLink(String text, String? href, String title) {
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () {
        if (widget.onTapLink != null) {
          widget.onTapLink!(text, href, title);
        }
      };
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  InlineSpan formatText(MarkdownStyleSheet styleSheet, String code) {
    code = code.replaceAll(RegExp(r'\n$'), '');
    if (widget.syntaxHighlighter != null) {
      return widget.syntaxHighlighter!.format(code);
    }
    return TextSpan(style: styleSheet.code, text: code);
  }
}
