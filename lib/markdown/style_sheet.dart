import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownStyleSheet {
  MarkdownStyleSheet({
    this.a,
    this.p,
    this.pPadding,
    this.h1,
    this.h1Padding,
    this.h2,
    this.h2Padding,
    this.h3,
    this.h3Padding,
    this.h4,
    this.h4Padding,
    this.h5,
    this.h5Padding,
    this.h6,
    this.h6Padding,
    this.strong,
    this.em,
    this.del,
    this.blockquote,
    this.listBullet,
    this.tableHead,
    this.tableBody,
    this.blockquoteDecoration,
    this.blockquotePadding,
    this.img,
    this.checkbox,
    this.horizontalRuleDecoration,
    this.blockSpacing,
    this.code,
    this.lineCodeDecoration,
    this.codeBlockDecoration,
    this.codeBlockPadding,
    this.tableColumnWidth = const FlexColumnWidth(),
    this.tableVerticalAlignment = TableCellVerticalAlignment.top,
    this.tableBorder,
    this.tableHeadAlign,
    this.tableCellsPadding = EdgeInsets.zero,
    this.tableCellsDecoration,
    this.textScaler,
    this.textScaleFactor,
  }) : _styles = <String, TextStyle?>{
          'a': a,
          'p': p,
          'li': p,
          'pre': p,
          'h1': h1,
          'h2': h2,
          'h3': h3,
          'h4': h4,
          'h5': h5,
          'h6': h6,
          'em': em,
          'strong': strong,
          'del': del,
          'blockquote': blockquote,
          'table': p,
          'th': tableHead,
          'td': tableBody,
          'code': code,
        };

  ///链接样式
  final TextStyle? a;

  ///段落样式
  final TextStyle? p;
  final EdgeInsets? pPadding;

  ///标题样式
  final TextStyle? h1;
  final EdgeInsets? h1Padding;
  final TextStyle? h2;
  final EdgeInsets? h2Padding;
  final TextStyle? h3;
  final EdgeInsets? h3Padding;
  final TextStyle? h4;
  final EdgeInsets? h4Padding;
  final TextStyle? h5;
  final EdgeInsets? h5Padding;
  final TextStyle? h6;
  final EdgeInsets? h6Padding;

  ///粗体字体样式
  final TextStyle? strong;

  ///斜体字体样式
  final TextStyle? em;

  ///删除线字体样式
  final TextStyle? del;

  ///引用字体样式
  final TextStyle? blockquote;

  ///列表头字体样式
  final TextStyle? listBullet;

  ///表头字体样式
  final TextStyle? tableHead;

  ///表体字体样式
  final TextStyle? tableBody;

  ///引用块结构样式
  final Decoration? blockquoteDecoration;

  ///引用块内边距
  final EdgeInsets? blockquotePadding;

  ///图片标题样式
  final TextStyle? img;

  ///复选框样式
  final TextStyle? checkbox;

  ///文段块行距
  final double? blockSpacing;

  ///分割线结构样式
  final Decoration? horizontalRuleDecoration;

  ///代码字体样式
  final TextStyle? code;

  ///行内代码结构样式
  final Decoration? lineCodeDecoration;

  ///代码块结构样式
  final Decoration? codeBlockDecoration;

  ///代码块内边距
  final EdgeInsets? codeBlockPadding;

  final TableColumnWidth tableColumnWidth;

  final TableCellVerticalAlignment tableVerticalAlignment;

  final TableBorder? tableBorder;

  final TextAlign? tableHeadAlign;

  final EdgeInsets tableCellsPadding;

  final Decoration? tableCellsDecoration;

  final TextScaler? textScaler;

  @Deprecated('Use textScaler instead.')
  final double? textScaleFactor;

  Map<String, TextStyle?> get styles => _styles;
  final Map<String, TextStyle?> _styles;

  factory MarkdownStyleSheet.fromTheme(ThemeData theme) {
    assert(theme.textTheme.bodyMedium?.fontSize != null);
    return MarkdownStyleSheet(
      a: const TextStyle(color: Colors.blue),
      p: theme.textTheme.bodyMedium,
      pPadding: EdgeInsets.zero,
      code: theme.textTheme.bodyMedium!.copyWith(
        fontFamily: 'monospace',
      ),
      h1: theme.textTheme.headlineSmall,
      h1Padding: EdgeInsets.zero,
      h2: theme.textTheme.titleLarge,
      h2Padding: EdgeInsets.zero,
      h3: theme.textTheme.titleMedium,
      h3Padding: EdgeInsets.zero,
      h4: theme.textTheme.bodyLarge,
      h4Padding: EdgeInsets.zero,
      h5: theme.textTheme.bodyLarge,
      h5Padding: EdgeInsets.zero,
      h6: theme.textTheme.bodyLarge,
      h6Padding: EdgeInsets.zero,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      del: const TextStyle(decoration: TextDecoration.lineThrough),
      blockquote: theme.textTheme.bodyMedium,
      checkbox: theme.textTheme.bodyMedium!.copyWith(
        color: theme.primaryColor,
      ),
      blockSpacing: 8.0,
      listBullet: theme.textTheme.bodyMedium,
      tableHead: const TextStyle(fontWeight: FontWeight.w600),
      tableBody: theme.textTheme.bodyMedium,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        color: theme.dividerColor,
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: const BoxDecoration(),
      blockquotePadding: const EdgeInsets.all(8.0),
      blockquoteDecoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
        border: Border(
          left: BorderSide(
            color: theme.brightness == Brightness.dark
                ? CupertinoColors.systemGrey4.darkColor
                : CupertinoColors.systemGrey4.color,
            width: 4,
          ),
        ),
      ),
      lineCodeDecoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
      codeBlockPadding: const EdgeInsets.all(8.0),
      codeBlockDecoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 5.0,
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }

  factory MarkdownStyleSheet.fromCupertinoTheme(CupertinoThemeData theme) {
    assert(theme.textTheme.textStyle.fontSize != null);
    return MarkdownStyleSheet(
      a: theme.textTheme.textStyle.copyWith(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.link.darkColor
            : CupertinoColors.link.color,
      ),
      p: theme.textTheme.textStyle,
      pPadding: EdgeInsets.zero,
      code: theme.textTheme.textStyle.copyWith(
        fontFamily: 'monospace',
      ),
      h1: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: theme.textTheme.textStyle.fontSize! + 10,
      ),
      h1Padding: EdgeInsets.zero,
      h2: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: theme.textTheme.textStyle.fontSize! + 8,
      ),
      h2Padding: EdgeInsets.zero,
      h3: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: theme.textTheme.textStyle.fontSize! + 6,
      ),
      h3Padding: EdgeInsets.zero,
      h4: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: theme.textTheme.textStyle.fontSize! + 4,
      ),
      h4Padding: EdgeInsets.zero,
      h5: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: theme.textTheme.textStyle.fontSize! + 2,
      ),
      h5Padding: EdgeInsets.zero,
      h6: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
      ),
      h6Padding: EdgeInsets.zero,
      em: theme.textTheme.textStyle.copyWith(
        fontStyle: FontStyle.italic,
      ),
      strong: theme.textTheme.textStyle.copyWith(
        fontWeight: FontWeight.bold,
      ),
      del: theme.textTheme.textStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
      blockquote: theme.textTheme.textStyle,
      checkbox: theme.textTheme.textStyle.copyWith(
        color: theme.primaryColor,
      ),
      blockSpacing: 8,
      listBullet: theme.textTheme.textStyle,
      tableBody: theme.textTheme.textStyle,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(color: CupertinoColors.separator, width: 0),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
      ),
      blockquotePadding: const EdgeInsets.all(16),
      blockquoteDecoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
        border: Border(
          left: BorderSide(
            color: theme.brightness == Brightness.dark
                ? CupertinoColors.systemGrey4.darkColor
                : CupertinoColors.systemGrey4.color,
            width: 4,
          ),
        ),
      ),
      lineCodeDecoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
      ),
      codeBlockPadding: const EdgeInsets.all(8),
      codeBlockDecoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.brightness == Brightness.dark
                ? CupertinoColors.systemGrey4.darkColor
                : CupertinoColors.systemGrey4.color,
          ),
        ),
      ),
    );
  }

  /// Creates a [MarkdownStyleSheet] based on the current style, with the
  /// provided parameters overridden.
  MarkdownStyleSheet copyWith({
    TextStyle? a,
    TextStyle? p,
    EdgeInsets? pPadding,
    TextStyle? code,
    TextStyle? h1,
    EdgeInsets? h1Padding,
    TextStyle? h2,
    EdgeInsets? h2Padding,
    TextStyle? h3,
    EdgeInsets? h3Padding,
    TextStyle? h4,
    EdgeInsets? h4Padding,
    TextStyle? h5,
    EdgeInsets? h5Padding,
    TextStyle? h6,
    EdgeInsets? h6Padding,
    TextStyle? em,
    TextStyle? strong,
    TextStyle? del,
    TextStyle? blockquote,
    TextStyle? img,
    TextStyle? checkbox,
    double? blockSpacing,
    TextStyle? listBullet,
    TextStyle? tableHead,
    TextStyle? tableBody,
    TextAlign? tableHeadAlign,
    TableBorder? tableBorder,
    TableColumnWidth? tableColumnWidth,
    EdgeInsets? tableCellsPadding,
    Decoration? tableCellsDecoration,
    TableCellVerticalAlignment? tableVerticalAlignment,
    Decoration? lineCodeDecoration,
    EdgeInsets? blockquotePadding,
    Decoration? blockquoteDecoration,
    EdgeInsets? codeBlockPadding,
    Decoration? codeBlockDecoration,
    Decoration? horizontalRuleDecoration,
    @Deprecated('Use textScaler instead.') double? textScaleFactor,
    TextScaler? textScaler,
  }) {
    assert(
      textScaler == null || textScaleFactor == null,
      'textScaleFactor is deprecated and cannot be specified when textScaler is specified.',
    );
    // If either of textScaler or textScaleFactor is non-null, pass null for the
    // other instead of the previous value, since only one is allowed.
    final TextScaler? newTextScaler =
        textScaler ?? (textScaleFactor == null ? this.textScaler : null);
    final double? nextTextScaleFactor =
        textScaleFactor ?? (textScaler == null ? this.textScaleFactor : null);
    return MarkdownStyleSheet(
      a: a ?? this.a,
      p: p ?? this.p,
      pPadding: pPadding ?? this.pPadding,
      code: code ?? this.code,
      h1: h1 ?? this.h1,
      h1Padding: h1Padding ?? this.h1Padding,
      h2: h2 ?? this.h2,
      h2Padding: h2Padding ?? this.h2Padding,
      h3: h3 ?? this.h3,
      h3Padding: h3Padding ?? this.h3Padding,
      h4: h4 ?? this.h4,
      h4Padding: h4Padding ?? this.h4Padding,
      h5: h5 ?? this.h5,
      h5Padding: h5Padding ?? this.h5Padding,
      h6: h6 ?? this.h6,
      h6Padding: h6Padding ?? this.h6Padding,
      em: em ?? this.em,
      strong: strong ?? this.strong,
      del: del ?? this.del,
      blockquote: blockquote ?? this.blockquote,
      img: img ?? this.img,
      checkbox: checkbox ?? this.checkbox,
      blockSpacing: blockSpacing ?? this.blockSpacing,
      listBullet: listBullet ?? this.listBullet,
      tableHead: tableHead ?? this.tableHead,
      tableBody: tableBody ?? this.tableBody,
      tableHeadAlign: tableHeadAlign ?? this.tableHeadAlign,
      tableBorder: tableBorder ?? this.tableBorder,
      tableColumnWidth: tableColumnWidth ?? this.tableColumnWidth,
      tableCellsPadding: tableCellsPadding ?? this.tableCellsPadding,
      tableCellsDecoration: tableCellsDecoration ?? this.tableCellsDecoration,
      tableVerticalAlignment:
          tableVerticalAlignment ?? this.tableVerticalAlignment,
      lineCodeDecoration: lineCodeDecoration ?? this.lineCodeDecoration,
      blockquotePadding: blockquotePadding ?? this.blockquotePadding,
      blockquoteDecoration: blockquoteDecoration ?? this.blockquoteDecoration,
      codeBlockPadding: codeBlockPadding ?? this.codeBlockPadding,
      codeBlockDecoration: codeBlockDecoration ?? this.codeBlockDecoration,
      horizontalRuleDecoration:
          horizontalRuleDecoration ?? this.horizontalRuleDecoration,
      textScaler: newTextScaler,
      textScaleFactor: nextTextScaleFactor,
    );
  }

  /// Returns a new text style that is a combination of this style and the given
  /// [other] style.
  MarkdownStyleSheet merge(MarkdownStyleSheet? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      a: a?.merge(other.a),
      p: p?.merge(other.p),
      pPadding: other.pPadding,
      code: code?.merge(other.code),
      h1: h1?.merge(other.h1),
      h1Padding: other.h1Padding,
      h2: h2?.merge(other.h2),
      h2Padding: other.h2Padding,
      h3: h3?.merge(other.h3),
      h3Padding: other.h3Padding,
      h4: h4?.merge(other.h4),
      h4Padding: other.h4Padding,
      h5: h5?.merge(other.h5),
      h5Padding: other.h5Padding,
      h6: h6?.merge(other.h6),
      h6Padding: other.h6Padding,
      em: em?.merge(other.em),
      strong: strong?.merge(other.strong),
      del: del?.merge(other.del),
      blockquote: blockquote!.merge(other.blockquote),
      img: img?.merge(other.img),
      checkbox: checkbox?.merge(other.checkbox),
      blockSpacing: other.blockSpacing,
      listBullet: listBullet?.merge(other.listBullet),
      tableHead: tableHead?.merge(other.tableHead),
      tableBody: tableBody?.merge(other.tableBody),
      tableHeadAlign: other.tableHeadAlign,
      tableBorder: other.tableBorder,
      tableColumnWidth: other.tableColumnWidth,
      tableCellsPadding: other.tableCellsPadding,
      tableCellsDecoration: other.tableCellsDecoration,
      tableVerticalAlignment: other.tableVerticalAlignment,
      blockquotePadding: other.blockquotePadding,
      blockquoteDecoration: other.blockquoteDecoration,
      lineCodeDecoration: other.lineCodeDecoration,
      codeBlockPadding: other.codeBlockPadding,
      codeBlockDecoration: other.codeBlockDecoration,
      horizontalRuleDecoration: other.horizontalRuleDecoration,
      textScaleFactor: other.textScaleFactor,
      // Only one of textScaler and textScaleFactor can be passed. If
      // other.textScaleFactor is non-null, then the sheet was created with a
      // textScaleFactor and the textScaler was derived from that, so should be
      // ignored so that the textScaleFactor continues to be set.
      textScaler: other.textScaleFactor == null ? other.textScaler : null,
    );
  }
}
