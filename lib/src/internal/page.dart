import 'package:puppeteer/puppeteer.dart' as puppeteer;

extension PageExtension on puppeteer.Page {
  Future<void> autoScroll() async {
    int totalHeight = 0;
    const distance = 800;
    while (true) {
      final scrollHeight =
          await evaluate<int>(''' document.body.scrollHeight ''');
      await evaluate('''  window.scrollBy(0, $distance); ''');
      totalHeight += distance;
      if (totalHeight >= scrollHeight) break;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
