import 'package:markdown/markdown.dart' as md;

class EmptyLineBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^(?:[ \t]*)$');

  const EmptyLineBlockSyntax();

  @override
  md.Node? parse(md.BlockParser parser) {
    final text = parser.current.content;
    parser.advance();
    // Don't actually emit anything.
    return md.Element('p', [md.Text(text)]);
  }
}
