import 'package:html/dom.dart' as dom;

extension ElementExtension on dom.Element {
  bool get isH1 => localName == 'h1';
  bool get isH2 => localName == 'h2';
  bool get isH3 => localName == 'h3';
  bool get isP => localName == 'p';
  bool get isImg => localName == 'img';
  bool get isFigure => localName == 'figure';
  bool get isPre => localName == 'pre';
}
