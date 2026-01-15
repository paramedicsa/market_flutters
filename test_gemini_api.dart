import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  // Load API key from environment
  final envFile = File('.env');
  String apiKey = '';

  if (await envFile.exists()) {
    final contents = await envFile.readAsString();
    final lines = contents.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty && !trimmed.startsWith('#')) {
        final parts = trimmed.split('=');
        if (parts.length == 2 && parts[0].trim() == 'GEMINI_API_KEY') {
          apiKey = parts[1].trim();
          break;
        }
      }
    }
  }

  if (apiKey.isEmpty) {
    debugPrint('❌ No API key found in .env file');
    return;
  }

  debugPrint('🔑 API Key found: ${apiKey.substring(0, 10)}...');
  debugPrint('🔑 API Key length: ${apiKey.length}');

  try {
    // Test basic model initialization - try different models
    debugPrint('🤖 Testing Gemini AI initialization...');

    // Try the correct model name for Gemini 1.5 Flash
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', // Using gemini-1.5-flash-latest for better API routing
      apiKey: apiKey,
    );
    debugPrint('✅ Model initialized successfully');

    // Test simple text generation (no image)
    debugPrint('📝 Testing simple text generation...');
    final content = [Content.text('Hello, can you respond with just "Hello back!"?')];
    final response = await model.generateContent(content);

    debugPrint('📥 Response received: ${response.text}');
    debugPrint('✅ Gemini API is working correctly!');

  } catch (e) {
    debugPrint('❌ Gemini API test failed: $e');

    // Check for specific error types
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('quota') || errorString.contains('limit')) {
      debugPrint('🚫 QUOTA ERROR: Your API key has exceeded its quota limits.');
      debugPrint('💡 Solutions:');
      debugPrint('   1. Check your Google AI Studio billing/quota settings');
      debugPrint('   2. Enable billing if not already enabled');
      debugPrint('   3. Wait for quota reset (usually monthly)');
      debugPrint('   4. Consider upgrading your plan');
    } else if (errorString.contains('invalid') || errorString.contains('unauthorized') || errorString.contains('403')) {
      debugPrint('🚫 AUTHENTICATION ERROR: Your API key is invalid or unauthorized.');
      debugPrint('💡 Solutions:');
      debugPrint('   1. Check that your API key is correct');
      debugPrint('   2. Make sure the key is for Gemini API (not other Google APIs)');
      debugPrint('   3. Verify the key hasn\'t expired');
      debugPrint('   4. Try creating a new API key in Google AI Studio');
    } else if (errorString.contains('not found') || errorString.contains('model')) {
      debugPrint('🚫 MODEL ERROR: The specified model is not available.');
      debugPrint('💡 Solutions:');
      debugPrint('   1. Check available models in Google AI Studio');
      debugPrint('   2. Try using "gemini-pro" instead');
      debugPrint('   3. Make sure your API key has access to the requested model');
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      debugPrint('🚫 NETWORK ERROR: Unable to connect to Google AI services.');
      debugPrint('💡 Solutions:');
      debugPrint('   1. Check your internet connection');
      debugPrint('   2. Verify firewall/proxy settings');
    } else {
      debugPrint('🚫 UNKNOWN ERROR: Please check the error details above.');
    }
  }
}
