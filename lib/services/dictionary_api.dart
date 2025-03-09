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

  /// Properly encodes Turkish characters in the URL to match browser behavior
  String _encodeWord(String word) {
    // First, ensure the word is lowercase like in browser requests
    String lowercaseWord = word.toLowerCase();

    // Using a more precise encoding to match browser behavior
    // For Turkish characters: ç, ğ, ı, i, ö, ş, ü
    Map<String, String> turkishChars = {
      'ç': '%C3%A7',
      'ğ': '%C4%9F',
      'ı': '%C4%B1',
      'i': 'i',
      'ö': '%C3%B6',
      'ş': '%C5%9F',
      'ü': '%C3%BC',
    };

    String encodedWord = lowercaseWord;
    turkishChars.forEach((key, value) {
      encodedWord = encodedWord.replaceAll(key, value);
    });

    // Handle regular ASCII characters
    String result = '';
    for (int i = 0; i < encodedWord.length; i++) {
      final char = encodedWord[i];
      // If it's already a percent-encoded sequence (from Turkish chars), keep it
      if (i < encodedWord.length - 2 && char == '%') {
        result += encodedWord.substring(i, i + 3);
        i += 2;
      }
      // If it's a regular ASCII letter or number, keep it
      else if ((char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) ||
          (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
        result += char;
      }
      // Otherwise encode it
      else {
        result += Uri.encodeComponent(char);
      }
    }

    print('Original word: $word, Encoded word: $result');
    return result;
  }

  /// Fetches word definition from the Turkish dictionary API
  /// Returns a WordDefinition object with the word and its meanings
  /// If word is not found, returns an empty WordDefinition
  Future<WordDefinition> fetchWord(String word) async {
    int attempts = 0;
    final encodedWord = _encodeWord(word);

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
