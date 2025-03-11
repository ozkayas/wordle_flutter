// This project supports only Turkish so this simple class is sufficient for managing app text.

class AppTxt {
  static const String playAgain = 'Tekrar Oyna';
  static const String showMeaning = 'Anlamı Göster';
  static const String invalidWord = 'Geçersiz Sözcük';
  static String targetWord(String word) => 'Sözcük: $word';
  static const settings = 'Ayarlar';
  static const theme = 'Tema';

  // Added magic strings from codebase
  static const String appTitle = 'Kelimece';
  static const String bravo = 'BRAVO 🎉';
  static const String gameOver = 'GAME OVER ⛔️';
}
