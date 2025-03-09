import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wordle_flutter/models/word_definition.dart';

class DictionaryApi {
  final String baseUrl = 'https://sozluk.gov.tr/gts';
  final Duration timeout = Duration(seconds: 15);
  final int maxRetries = 3;

  /// Creates a custom HTTP client with specific settings
  http.Client _createClient() {
    return http.Client();
  }

  /// Convert Turkish uppercase letters to their proper lowercase equivalents
  String _turkishToLowerCase(String word) {
    // Special case: In Turkish, uppercase 'I' becomes lowercase 'ı' (dotless i)
    // while uppercase 'İ' (dotted I) becomes lowercase 'i'
    StringBuffer result = StringBuffer();

    for (int i = 0; i < word.length; i++) {
      final char = word[i];

      switch (char) {
        case 'I':
          result.write('ı'); // Convert uppercase I to lowercase dotless ı
          break;
        case 'İ':
          result.write('i'); // Convert uppercase dotted İ to lowercase i
          break;
        case 'Ç':
          result.write('ç');
          break;
        case 'Ğ':
          result.write('ğ');
          break;
        case 'Ö':
          result.write('ö');
          break;
        case 'Ş':
          result.write('ş');
          break;
        case 'Ü':
          result.write('ü');
          break;
        default:
          // For other characters, use standard lowercase conversion
          result.write(char.toLowerCase());
          break;
      }
    }

    return result.toString();
  }

  /// Properly encodes Turkish characters in the URL to match browser behavior
  String _encodeWord(String word) {
    // First, ensure the word is lowercase using Turkish rules
    String lowercaseWord = _turkishToLowerCase(word);

    print('Original word: $word, Turkish lowercase: $lowercaseWord');

    // For debugging - show each character's code point
    for (int i = 0; i < lowercaseWord.length; i++) {
      print('Char at $i: ${lowercaseWord[i]}, Code: ${lowercaseWord.codeUnitAt(i)}');
    }

    // Direct encoding approach - process character by character
    StringBuffer result = StringBuffer();

    for (int i = 0; i < lowercaseWord.length; i++) {
      final char = lowercaseWord[i];
      final codeUnit = lowercaseWord.codeUnitAt(i);

      // Handle Turkish specific characters
      switch (char) {
        case 'ç':
          result.write('%C3%A7');
          break;
        case 'ğ':
          result.write('%C4%9F');
          break;
        case 'ı': // This is the Turkish dotless i (different from ASCII 'i')
          result.write('%C4%B1');
          break;
        case 'ö':
          result.write('%C3%B6');
          break;
        case 'ş':
          result.write('%C5%9F');
          break;
        case 'ü':
          result.write('%C3%BC');
          break;
        default:
          // If it's a basic Latin letter (a-z) or digit (0-9), keep it as is
          if ((codeUnit >= 97 && codeUnit <= 122) || // a-z
              (codeUnit >= 48 && codeUnit <= 57)) {
            // 0-9
            result.write(char);
          } else {
            // For any other character, use standard URL encoding
            result.write(Uri.encodeComponent(char));
          }
          break;
      }
    }

    String encodedWord = result.toString();
    print('Encoded result: $encodedWord');

    return encodedWord;
  }

  /// Fetches word definition from the Turkish dictionary API
  /// Returns a WordDefinition object with the word and its meanings
  /// If word is not found, returns an empty WordDefinition
  Future<WordDefinition> fetchWord(String word) async {
    int attempts = 0;
    final encodedWord = _encodeWord(word);

    print('Final encoded word used in URL: $encodedWord');

    while (attempts < maxRetries) {
      http.Client? client;

      try {
        attempts++;
        client = _createClient();

        // Build request with proper URL encoding and headers
        final url = Uri.parse('$baseUrl?ara=$encodedWord');

        // Add headers to mimic a browser request - using more common browser headers
        final headers = {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
          'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
          'Connection': 'keep-alive',
        };

        print('Attempting to fetch: ${url.toString()}');
        final response = await client.get(url, headers: headers).timeout(timeout);

        print('Response status: ${response.statusCode}');
        print('Response body length: ${response.body.length}');

        if (response.statusCode == 200) {
          // Check if response is empty or contains error message
          if (response.body == '[]' || response.body.contains('"error":')) {
            return WordDefinition.empty();
          }

          try {
            final List<dynamic> jsonData = json.decode(response.body);
            if (jsonData.isEmpty) {
              return WordDefinition.empty();
            }

            // Parse the word definition using our model
            return WordDefinition.fromJson(jsonData[0]);
          } on FormatException catch (e) {
            print('JSON parsing error: $e');
            print('Response body: ${response.body.substring(0, min(100, response.body.length))}...');
            return WordDefinition.empty();
          }
        }

        print('Received status code ${response.statusCode}. Attempt $attempts of $maxRetries');
        if (attempts < maxRetries) {
          await Future.delayed(Duration(seconds: 2) * attempts);
          continue;
        }
      } catch (e) {
        print('Error fetching word definition (attempt $attempts): $e');

        // Handle specific network errors
        if (e is SocketException || e is HttpException) {
          print('Network error: $e');
        }

        if (attempts < maxRetries) {
          await Future.delayed(Duration(seconds: 2) * attempts);
          continue;
        }
      } finally {
        client?.close();
      }
    }

    return WordDefinition.empty();
  }

  /// Simple method that just gets the meanings as strings
  /// Returns a list of meanings for the word or an empty list if not found
  Future<List<String>> fetchMeanings(String word) async {
    final wordDefinition = await fetchWord(word);
    return wordDefinition.meanings;
  }

  /// Alternative direct method using a different approach
  /// This is a fallback in case the main method fails
  Future<List<String>> fetchMeaningsAlternative(String word) async {
    int attempts = 0;
    final encodedWord = _encodeWord(word);

    while (attempts < maxRetries) {
      http.Client? client;

      try {
        attempts++;
        client = _createClient();

        // Try with a simpler request approach
        final url = Uri.parse('$baseUrl?ara=$encodedWord');

        final headers = {
          'User-Agent': 'Mozilla/5.0',
          'Accept': '*/*',
        };

        final response = await client.get(url, headers: headers).timeout(Duration(seconds: 20));

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          try {
            final List<dynamic> jsonData = json.decode(response.body);
            if (jsonData.isNotEmpty && jsonData[0] is Map) {
              final Map<String, dynamic> wordData = jsonData[0];
              if (wordData.containsKey('anlamlarListe')) {
                final List<dynamic> anlamlarListe = wordData['anlamlarListe'];
                return anlamlarListe.map<String>((anlam) => anlam['anlam'] as String).toList();
              }
            }
          } catch (e) {
            print('JSON parsing error in alternative method: $e');
          }
        }
      } catch (e) {
        print('Error in alternative fetch method: $e');
      } finally {
        client?.close();
      }

      attempts++;
      await Future.delayed(Duration(seconds: 2));
    }

    return [];
  }
}

// Helper function for min
int min(int a, int b) => a < b ? a : b;
