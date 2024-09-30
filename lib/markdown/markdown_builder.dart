import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '_functions_io.dart';
import 'style_sheet.dart';
import 'markdownWidget.dart';

final List<String> _kBlockTags = <String>[
  'p',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'li',
  'blockquote',
  'pre',
  'ol',
  'ul',
  'hr',
  'table',
  'thead',
  'tbody',
  'tr',
  'section',
  'br'
];

const List<String> _kStyleTags = <String>[
  'a',
  'p',
  'li',
  'pre',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'em',
  'strong',
  'del',
  'blockquote',
  'table',
  'th',
  'td',
  'code',
];

const List<String> _kListTags = <String>['ul', 'ol'];

bool _isBlockTag(String? tag) => _kBlockTags.contains(tag);

bool _isListTag(String tag) => _kListTags.contains(tag);

bool _isStyleTag(String tag) => _kStyleTags.contains(tag);

class _TableElement {
  final List<TableRow> rows = <TableRow>[];
}

class _BlockElement {
  _BlockElement(this.tag);

  final String? tag;
  final List<Widget> children = <Widget>[];

  int nextListIndex = 0;
}

class MarkdownBuilder implements md.NodeVisitor {
  final MarkdownBuilderDelegate delegate;
  final MarkdownStyleSheet styleSheet;
  final MarkdownBulletBuilder? bulletBuilder;
  final MarkdownImageBuilder? imageBuilder;
  final String? imageDirectory;
  final bool softLineBreak;

  final List<_BlockElement> _blockStack = [];
  final List<InlineSpan> _textStack = [];
  final List<TextStyle?> _styleStack = [];

  final List<String> _listIndents = <String>[];

  final List<_TableElement> _tables = <_TableElement>[];

  final List<GestureRecognizer> _linkHandlers = <GestureRecognizer>[];

  String? _currentBlockTag;
  String? _lastVisitedTag;

  bool _isInBlockquote = false;

  MarkdownBuilder({
    required this.delegate,
    required this.styleSheet,
    this.bulletBuilder,
    this.imageBuilder,
    this.imageDirectory,
    this.softLineBreak = false,
  });

  List<Widget> build(List<md.Node> nodes) {
    _blockStack.clear();
    _textStack.clear();
    _styleStack.clear();
    _listIndents.clear();
    _tables.clear();
    _linkHandlers.clear();
    _isInBlockquote = false;

    _blockStack.add(_BlockElement(null));
    for (final md.Node node in nodes) {
      assert(_blockStack.length == 1);
      node.accept(this);
    }

    assert(!_isInBlockquote);
    return _blockStack.single.children;
  }

  @override
  bool visitElementBefore(md.Element element) {
    final String tag = element.tag;
    _currentBlockTag ??= tag;
    _lastVisitedTag = tag;
    int? start;
    if (_isBlockTag(tag)) {
      _addLineIfNeeded();
      //文本块
      if (_isListTag(tag)) {
        _listIndents.add(tag);
        if (element.attributes['start'] != null) {
          start = int.parse(element.attributes['start']!) - 1;
        }
      } else if (tag == 'blockquote') {
        _isInBlockquote = true;
      } else if (tag == 'table') {
        _tables.add(_TableElement());
      } else if (tag == 'tr') {
        final int length = _tables.single.rows.length;
        BoxDecoration? decoration =
            styleSheet.tableCellsDecoration as BoxDecoration?;
        if (length == 0 || length.isOdd) {
          decoration = null;
        }
        _tables.single.rows.add(TableRow(
          decoration: decoration,
          children: List<Widget>.empty(growable: true),
        ));
      }
      final _BlockElement bElement = _BlockElement(tag);
      if (start != null) {
        bElement.nextListIndex = start;
      }
      _blockStack.add(bElement);
    } else {
      if (tag == 'a') {
        final String? text = extractTextFromElement(element);
        // Don't add empty links
        if (text == null) {
          return false;
        }
        final String? destination = element.attributes['href'];
        final String title = element.attributes['title'] ?? '';

        _linkHandlers.add(
          delegate.createLink(text, destination, title),
        );
      }
    }
    if (_isStyleTag(tag)) {
      _styleStack.add(styleSheet.styles[tag]);
    }

    return true;
  }

  @override
  void visitText(md.Text text) {
    // Don't allow text directly under the root.
    if (_blockStack.last.tag == null) {
      return;
    }

    String trimText(String text) {
      final RegExp softLineBreakPattern = RegExp(r' ?\n *');
      if (softLineBreak) {
        return text;
      }
      return text.replaceAll(softLineBreakPattern, ' ');
    }

    InlineSpan? child;
    if (_blockStack.last.tag == 'pre') {
      child = delegate.formatText(styleSheet, text.text);
    } else if (_lastVisitedTag == 'code') {
      TextStyle style = const TextStyle();
      for (var element in _styleStack) {
        style = style.merge(element);
      }
      child = WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Container(
          clipBehavior:
              styleSheet.lineCodeDecoration != null ? Clip.hardEdge : Clip.none,
          decoration: styleSheet.lineCodeDecoration,
          child: Text(
            text.text,
            style: style,
          ),
        ),
      );
    } else {
      TextStyle style = const TextStyle();
      for (var element in _styleStack) {
        style = style.merge(element);
      }
      child = TextSpan(
        style: style,
        text: _isInBlockquote ? text.text : trimText(text.text),
        recognizer: _linkHandlers.isNotEmpty ? _linkHandlers.last : null,
      );
    }
    _textStack.add(child);
    _lastVisitedTag = null;
  }

  @override
  void visitElementAfter(md.Element element) {
    String tag = element.tag;
    if (_isBlockTag(tag)) {
      _addLineIfNeeded();
      final _BlockElement current = _blockStack.removeLast();
      Widget child;
      if (current.children.isNotEmpty) {
        child = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: current.children,
        );
      } else {
        child = const SizedBox.shrink();
      }
      if (_isListTag(tag)) {
        assert(_listIndents.isNotEmpty);
        _listIndents.removeLast();
      } else if (tag == 'li') {
        if (_listIndents.isNotEmpty) {
          Widget bullet;
          final el = element.children?.firstOrNull;
          if (el is md.Element && el.attributes['type'] == 'checkbox') {
            bullet = const SizedBox.shrink();
          } else {
            bullet = _buildBullet(_listIndents.last);
          }
          child = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              bullet,
              Flexible(
                fit: FlexFit.loose,
                child: child,
              )
            ],
          );
        }
      } else if (tag == 'table') {
        child = Table(
          defaultColumnWidth: styleSheet.tableColumnWidth,
          defaultVerticalAlignment: styleSheet.tableVerticalAlignment,
          border: styleSheet.tableBorder,
          children: _tables.removeLast().rows,
        );
      } else if (tag == 'blockquote') {
        _isInBlockquote = false;
        child = DecoratedBox(
          decoration: styleSheet.blockquoteDecoration ??
              BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2.0),
              ),
          child: Padding(
            padding: styleSheet.blockquotePadding ?? const EdgeInsets.all(8.0),
            child: child,
          ),
        );
      } else if (tag == 'pre') {
        child = Container(
          clipBehavior:
              styleSheet.codeBlockPadding != null ? Clip.hardEdge : Clip.none,
          decoration: styleSheet.codeBlockDecoration,
          padding: styleSheet.codeBlockPadding,
          child: child,
        );
      } else if (tag == 'hr') {
        child = Container(decoration: styleSheet.horizontalRuleDecoration);
      }
      _addBlockChild(child);
    } else {
      if (tag == 'img') {
        _textStack.add(WidgetSpan(
            child: _buildImage(
          element.attributes['src']!,
          element.attributes['title'],
          element.attributes['alt'],
        )));
      } else if (tag == 'br') {
        //todo
      } else if (tag == 'th' || tag == 'td') {
        TextAlign? align;
        final String? alignAttribute = element.attributes['align'];
        if (alignAttribute == null) {
          align = tag == 'th' ? styleSheet.tableHeadAlign : TextAlign.left;
        } else {
          switch (alignAttribute) {
            case 'left':
              align = TextAlign.left;
            case 'center':
              align = TextAlign.center;
            case 'right':
              align = TextAlign.right;
          }
        }
        final Widget child = _buildTableCell(
          textAlign: align,
        );
        _tables.single.rows.last.children.add(child);
      } else if (tag == 'a') {
        _linkHandlers.removeLast();
      } else if (tag == 'sup') {
        InlineSpan? textSpan = _textStack.lastOrNull;
        if (textSpan is TextSpan) {
          _textStack.add(TextSpan(
            recognizer: textSpan.recognizer,
            text: element.textContent,
            style: textSpan.style?.copyWith(
              fontFeatures: <FontFeature>[
                const FontFeature.enable('sups'),
              ],
            ),
          ));
        }
      }
    }
    if (_isStyleTag(tag)) {
      _styleStack.removeLast();
    }
    if (_currentBlockTag == tag) {
      _currentBlockTag = null;
    }
    _lastVisitedTag = tag;
  }

  Widget _buildBullet(String listTag) {
    final int index = _blockStack.last.nextListIndex;
    final bool isUnordered = listTag == 'ul';

    if (bulletBuilder != null) {
      return bulletBuilder!(
        index,
        isUnordered ? BulletStyle.unorderedList : BulletStyle.orderedList,
        _listIndents.length - 1,
      );
    }

    if (isUnordered) {
      return Container(
        constraints: const BoxConstraints(minWidth: 15),
        child: Text(
          '•',
          textAlign: TextAlign.center,
          style: styleSheet.listBullet,
        ),
      );
    }
    return Container(
      constraints: const BoxConstraints(minWidth: 15),
      child: Text(
        '${index + 1}.',
        style: styleSheet.listBullet,
      ),
    );
  }

  void _addBlockChild(Widget child) {
    final _BlockElement parent = _blockStack.last;
    if (parent.children.isNotEmpty) {
      parent.children.add(SizedBox(height: styleSheet.blockSpacing));
    }
    parent.children.add(child);
    parent.nextListIndex += 1;
  }

  String? extractTextFromElement(md.Node element) {
    return element is md.Element && (element.children?.isNotEmpty ?? false)
        ? element.children!
            .map((md.Node e) =>
                e is md.Text ? e.text : extractTextFromElement(e))
            .join()
        : (element is md.Element && (element.attributes.isNotEmpty)
            ? element.attributes['alt']
            : '');
  }

  Widget _buildRichText(TextSpan text, {TextAlign? textAlign, String? key}) {
    //Adding a unique key prevents the problem of using the same link handler for text spans with the same text
    final Key k = key == null ? UniqueKey() : Key(key);
    return Text.rich(
      text,
      textScaler: styleSheet.textScaler,
      textAlign: textAlign ?? TextAlign.start,
      key: k,
    );
  }

  void _addLineIfNeeded() {
    if (_textStack.isEmpty) {
      return;
    }
    Widget mergedInlines =
        _buildRichText(TextSpan(children: List.from(_textStack)));
    _textStack.clear();
    _addBlockChild(mergedInlines);
  }

  Widget _buildTableCell({TextAlign? textAlign}) {
    Widget mergedInlines = _buildRichText(
        TextSpan(children: List.from(_textStack)),
        textAlign: textAlign);
    _textStack.clear();

    return TableCell(
      child: Padding(
        padding: styleSheet.tableCellsPadding,
        child: mergedInlines,
      ),
    );
  }

  Widget _buildImage(String src, String? title, String? alt) {
    final List<String> parts = src.split('#');
    if (parts.isEmpty) {
      return const SizedBox();
    }

    final String path = parts.first;
    double? width;
    double? height;
    if (parts.length == 2) {
      final List<String> dimensions = parts.last.split('x');
      if (dimensions.length == 2) {
        width = double.tryParse(dimensions[0]);
        height = double.tryParse(dimensions[1]);
      }
    }

    final Uri uri = Uri.parse(path);
    Widget child;
    if (imageBuilder != null) {
      child = imageBuilder!(uri, title, alt);
    } else {
      child = kDefaultImageBuilder(uri, imageDirectory, width, height);
    }

    if (_linkHandlers.isNotEmpty) {
      final TapGestureRecognizer recognizer =
          _linkHandlers.last as TapGestureRecognizer;
      return GestureDetector(onTap: recognizer.onTap, child: child);
    } else {
      return child;
    }
  }
}
