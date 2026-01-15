import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistDashboardScreen extends StatefulWidget {
  const ArtistDashboardScreen({super.key});
  @override
  State<ArtistDashboardScreen> createState() => _ArtistDashboardScreenState();
}

class _ArtistDashboardScreenState extends State<ArtistDashboardScreen> {
  String? _currency; // 'ZAR' or 'USD'
  bool _showExplore = false; // New state to control the explore section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFE040FB), // pink-purple
                Color(0xFF7C4DFF), // purple
                Color(0xFF00B0FF), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            'Artist Dashboard',
            style: const TextStyle(
              fontFamily: 'CherryCreamSoda',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This will be masked by the shader
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            _showExplore
                ? _buildExploreSection()
                : _currency == 'ZAR'
                    ? _buildRandPackages()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome card at the top
                          Card(
                            color: Colors.black,
                            elevation: 12,
                            shadowColor: Colors.white.withValues(alpha: (0.4 * 255)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Color(0xFF7C4DFF), // purple
                                            Color(0xFF00B0FF), // blue
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        'Welcome to the Artist Dashboard! 🎨',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'CherryCreamSoda',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // masked by shader
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'IndieFlower',
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Last year, our creative community achieved over 128,000 sales!\n'),
                                        const TextSpan(text: 'The app has been downloaded by more than 50,000 people, with 7,000+ regular customers and 200+ talented small artists.\n\n'),
                                        TextSpan(text: 'We are ',),
                                        TextSpan(
                                          text: 'obsessed',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB), // same as title gradient start
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(text: ' with two things: '),
                                        TextSpan(
                                          text: 'beautiful',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB),
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(text: ', '),
                                        TextSpan(
                                          text: 'unique creations',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(text: ' and incredibly happy customers. It’s a formula that '),
                                        TextSpan(
                                          text: 'works',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(text: '—we currently see over 7,000 returning customers every month. To help you reach this audience and grow your brand, we have built a world-class fulfillment and security system. Here is how we '),
                                        TextSpan(
                                          text: 'work together',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(text: ' for your '),
                                        TextSpan(
                                          text: 'success',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE040FB),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Currency section below the welcome card
                          const Text('Currency:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shadowColor: Colors.cyanAccent,
                                    elevation: _currency == 'ZAR' ? 12 : 2,
                                    foregroundColor: _currency == 'ZAR' ? Colors.purpleAccent : Colors.white,
                                    side: BorderSide(color: _currency == 'ZAR' ? Colors.purpleAccent : Colors.cyan, width: 2),
                                  ),
                                  onPressed: () => setState(() => _currency = 'ZAR'),
                                  child: const Text('Rand (ZAR)'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shadowColor: Colors.cyanAccent,
                                    elevation: _currency == 'USD' ? 12 : 2,
                                    foregroundColor: _currency == 'USD' ? Colors.purpleAccent : Colors.white,
                                    side: BorderSide(color: _currency == 'USD' ? Colors.purpleAccent : Colors.cyan, width: 2),
                                  ),
                                  onPressed: () => setState(() => _currency = 'USD'),
                                  child: const Text('US Dollar (USD)'),
                                ),
                              ),
                            ],
                          ),
                          // Arrow and speech bubble below currency
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.arrow_upward, size: 36, color: Color(0xFFE040FB)),
                                const SizedBox(height: 4),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Color(0xFFE040FB), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyanAccent.withValues(alpha: (0.2 * 255)),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Column(
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [
                                              Color(0xFFE040FB),
                                              Color(0xFF7C4DFF),
                                              Color(0xFF00B0FF),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: Text(
                                          'Ok, Let\'s Start!',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'CherryCreamSoda',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // masked by shader
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Please choose your currency above.\nIf you\'re in South Africa, use the Rand. International artists, use the US Dollar. This is how your dashboard sales will be processed, and when you upload products and receive payouts! 🎉',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'IndieFlower',
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            // Back button at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_showExplore) {
                        setState(() => _showExplore = false);
                      } else if (_currency != null) {
                        setState(() => _currency = null);
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IndieFlower',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFE040FB), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFE040FB), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: (0.2 * 255)),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFE040FB),
                          Color(0xFF7C4DFF),
                          Color(0xFF00B0FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'We are happy to see you\'re eager to begin!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // masked by shader
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'But first, let\'s learn how Spoil Me Vintage Artist section works, then we decide.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'IndieFlower',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE040FB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _showExplore = true;
                      });
                    },
                    child: const Text('Ok, Show Me!'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreSection() {
    final double questionCardWidth = MediaQuery.of(context).size.width * 0.85;
    // Helper to style the label before the colon
    TextSpan labelSpan(String label, Color color) {
      // Count words in label (split by space, ignore trailing colon)
      final wordCount = label.replaceAll(':', '').trim().split(RegExp(r'\s+')).length;
      final isShortLabel = wordCount >= 1 && wordCount <= 4;
      return TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: isShortLabel ? 15 : 13, // One size larger for 1-4 word labels
        ),
      );
    }
    // Helper to style the value after the colon
    TextSpan valueSpan(String value) => TextSpan(
          text: value,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 13,
          ),
        );
    // Helper to build a line with label: value
    Widget labelValue(String text, Color color) {
      final idx = text.indexOf(':');
      if (idx > 0) {
        final label = text.substring(0, idx + 1);
        final value = text.substring(idx + 1);
        return RichText(
          text: TextSpan(
            children: [
              labelSpan(label, color),
              valueSpan(value),
            ],
          ),
        );
      } else {
        return Text(
          text,
          style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 13),
        );
      }
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Title Card
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFE040FB), width: 2), // pink-purple border like speech bubble
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: (0.2 * 255)),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFE040FB),
                          Color(0xFF7C4DFF),
                          Color(0xFF00B0FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Growing Your Art with Spoil Me Vintage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // masked by shader
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'The Artist Partnership Guide',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'CherryCreamSoda',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome to the Spoil Me Vintage family! We are obsessed with two things: beautiful, unique creations and incredibly happy customers. It’s a formula that works—we currently see over 7,000 returning customers every month. To help you reach this audience and grow your brand, we have built a world-class fulfillment and security system. Here is how we work together for your success.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IndieFlower',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 1. The Worcester Hub: Your Logistics Partner
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF1976D2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1976D2).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '1. The Worcester Hub: Your Logistics Partner',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'We’ve learned that for a customer to "feel spoiled," delivery must be fast and perfect. To ensure this, we handle all fulfillment from our dedicated Worcester Hub.',
                    Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Your Artist Drawer: Once your products are approved, you’ll ship your stock to us. You only need one item per product slot to go live! We store your work in your personal, secure "Artist Drawer."',
                    Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Inventory Freedom: Want to ensure you never sell out? You can send backup stock for the same product. There is a small handling fee of R2 for each extra unit, payable when we accept the stock.',
                    Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Zero-Loss Shipping: You pay to ship your items to the Hub, but we ensure you don’t lose a cent of profit. Simply email us your shipping invoice; we divide that cost by your total items and factor it into the retail price. The customer covers the logistics, and your margins stay protected.',
                    Color(0xFF1976D2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 2. Shipping & Packaging Standards
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF00B0FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00B0FF).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '2. Shipping & Packaging Standards',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFF00B0FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'To protect your hard work from scratches or tangles, we maintain high packaging standards:',
                    Color(0xFF00B0FF),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Individual Protection: Every item must be in its own separate packet (we prefer oxidized bags or zip-locks).',
                    Color(0xFF00B0FF),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Professional Discount: ', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Color(0xFF00B0FF), fontSize: 13)),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.white),
                            children: [
                              TextSpan(text: "Don't have packaging? You can buy the correct bags here "),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => _launchUrl('https://temu.to/k/eaoa8wczzay'),
                                  child: Text(
                                    'Oxidized Bags',
                                    style: TextStyle(
                                      color: Color(0xFF00B0FF),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(text: ' / '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => _launchUrl('https://temu.to/k/eqoigrnxrl0'),
                                  child: Text(
                                    'Jewelry Bags',
                                    style: TextStyle(
                                      color: Color(0xFF00B0FF),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(text: ' and receive an exclusive artist discount.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Our Policy: We cannot accept jewelry sent loose or mixed together in a box. We want your customers to receive their items in pristine, "boutique" condition.',
                    Color(0xFF00B0FF),
                  ),
                  const SizedBox(height: 18), // Divider line above Shipping Security section
                  Divider(color: Color(0xFF00B0FF), thickness: 1),
                  const SizedBox(height: 10),
                  // New Section: Shipping Security: The "Triple-Layer" Method
                  Center(
                    child: Text(
                      'Shipping Security: The "Triple-Layer" Method',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 15,
                        color: Color(0xFF00B0FF),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _labelValueColor(
                    'Your jewelry is delicate, and while couriers are fast, they can sometimes be rough. To ensure your art arrives at the Worcester Hub in boutique condition, we highly recommend our Triple-Layer Protection strategy:',
                    Color(0xFF00B0FF),
                  ),
                  const SizedBox(height: 6),
                  _labelValueColor('The Individual Wrap: Place each item in its own oxidized bag or zip-lock.', Color(0xFF00B0FF)),
                  _labelValueColor('The Inner Shield: Place all your bagged items together inside a small, sturdy box.', Color(0xFF00B0FF)),
                  _labelValueColor('The Outer Shell: Place that box inside your courier flyer or shipping bag.', Color(0xFF00B0FF)),
                  const SizedBox(height: 6),
                  _labelValueColor('Why do we recommend this? This "box-inside-a-bag" method prevents your jewelry from being crushed or bent by other heavy packages during transit.', Color(0xFF00B0FF)),
                  const SizedBox(height: 6),
                  _labelValueColor('What happens if an item arrives damaged? If your items are not boxed and arrive damaged, we will notify you immediately via your unboxing video. Because we only sell the best quality at full price, you will have two choices to handle damaged arrivals:', Color(0xFF00B0FF)),
                  _labelValueColor('The Vault Recovery: We can list the item in "The Vault" at a discounted price, allowing you to recover your material costs.', Color(0xFF00B0FF)),
                  _labelValueColor('The Return: We can ship the item back to you for repair or replacement (shipping costs in this instance will be at the artist\'s expense).', Color(0xFF00B0FF)),
                  const SizedBox(height: 6),
                  _labelValueColor('By following the Triple-Layer Method, you ensure your products go straight from the delivery truck to the "Ready to Sell" shelf!', Color(0xFF00B0FF)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 3. Total Transparency (Our Unboxing Video)
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFBA68C8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFBA68C8).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '3. Total Transparency (Our Unboxing Video)',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFFBA68C8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'We treat your art like the treasure it is. To ensure total honesty, we use a "Shared Proof" system:',
                    Color(0xFFBA68C8),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Secure Reception: Only dedicated staff can sign for your packages.',
                    Color(0xFFBA68C8),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'The Video Proof: Every time we open an artist\'s box, we record a continuous unboxing video. We send this to you immediately. This proves exactly what arrived and what condition it was in, protecting you from any errors or fraud.',
                    Color(0xFFBA68C8),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Our Responsibility: We take full responsibility for your items the moment the package is signed for at our Hub.',
                    Color(0xFFBA68C8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 4. Our "Peace of Mind" Guarantee
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFD81B60), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD81B60).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '4. Our "Peace of Mind" Guarantee',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFFD81B60),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'We are so confident in our security that we offer an industry-leading protection plan:',
                    Color(0xFFD81B60),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Theft or Damage: If an item is lost or damaged while in our care at the Hub, we refund you the Cost Price PLUS a 10% fee.',
                    Color(0xFFD81B60),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'The Final Mile: Once an item leaves the Hub for the customer, our standard responsibility ends. If you want 100% coverage for the transit to the customer’s door, ask us about our Artist Insurance Packages.',
                    Color(0xFFD81B60),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 5. Pricing & Your Profit Dashboard
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF43A047), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF43A047).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '5. Pricing & Your Profit Dashboard',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFF43A047),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'You have full control over your earnings via your Artist Dashboard.',
                    Color(0xFF43A047),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Smart Pricing: You enter your Cost Price and your Preferred Selling Price.',
                    Color(0xFF43A047),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Expert Coaching: Our team reviews the Market RRP (Recommended Retail Price). If we see your price is too high compared to competitors, we’ll advise you or update it to ensure you actually make sales. Your dashboard will even show you the "estimated site price" for similar items to help you stay competitive.',
                    Color(0xFF43A047),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Ultra-Low Fees: We take just 3% from your profit. This isn\'t a platform fee; it simply covers bank transaction costs and handling. The rest is 100% yours.',
                    Color(0xFF43A047),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 6. Reliable Payouts (The Safety Window)
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF8BC34A), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8BC34A).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '6. Reliable Payouts (The Safety Window)',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFF8BC34A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'We want to ensure that when you get paid, the money is yours to keep forever.',
                    Color(0xFF8BC34A),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'The Timeline: We offer customers a 7-day return policy. To account for delivery time (max 21 business days) and the return window, funds are held in a "Security Window."',
                    Color(0xFF8BC34A),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Dashboard Tracking: You will see your sales immediately. They will show as "Pending" and switch to "Ready for Payout" once the security window closes.',
                    Color(0xFF8BC34A),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Bi-Weekly EFT: We pay out every second Friday via EFT directly to your South African bank account. Depending on your bank, funds usually reflect within 3–5 business days.',
                    Color(0xFF8BC34A),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'Tax: Currently, we do not charge VAT on products. Managing your personal income tax remains your responsibility.',
                    Color(0xFF8BC34A),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 7. Managing Returns & Sales
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFF06292), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF06292).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '7. Managing Returns & Sales',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFFF06292),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelValue(
                    'We are your partners in selling. If an item is returned, we handle the stress:',
                    Color(0xFFF06292),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'The Restock: If the item is "as new," we book it back into your drawer to sell again at full price—no extra shipping for you!',
                    Color(0xFFF06292),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    'The Vault: If an item has a minor flaw, we move it to The Vault. We sell these at near-cost price with full transparency to the customer, helping you recover your material costs rather than taking a total loss.',
                    Color(0xFFF06292),
                  ),
                  const SizedBox(height: 8),
                  labelValue(
                    '3-Month Review: If an item hasn\'t sold after 3 months, we will reach out personally to discuss new promotions or strategies to get your stock moving!',
                    Color(0xFFF06292),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 8. Store Management & Staying Ahead
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  width: 3,
                  style: BorderStyle.solid,
                  color: Colors.transparent,
                ),
                gradient: null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    width: 3,
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellowAccent,
                      Colors.orangeAccent,
                      Colors.pinkAccent,
                      Colors.purpleAccent,
                      Colors.blueAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Colors.yellowAccent,
                                Colors.orangeAccent,
                                Colors.pinkAccent,
                                Colors.purpleAccent,
                                Colors.blueAccent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            '8. Store Management & Staying Ahead',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'CherryCreamSoda',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // masked by shader
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Subscription & Draft Status
                      _rainbowSection(
                        title: 'The Subscription & "Draft" Status',
                        color: Colors.yellowAccent,
                        content: [
                          'To keep your "Artist Drawer" and digital storefront active, a monthly subscription is required.',
                          'The 48-Hour Window: If a subscription payment does not go through, we provide a 48-hour grace period to rectify it.',
                          'Automatic Draft Status: On the 2nd day after a missed payment, your items will automatically be moved to "Draft" status. This means they are no longer live or visible to customers.',
                          'The Pro-Tip: We use "Draft Status" as a protective measure for your brand. We never want a customer to fall in love with your art only to find an inactive storefront. Moving items to Draft ensures that when you are live, you are 100% ready to sell, protecting your reputation and ours.'
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Boosting Your Sales
                      _rainbowSection(
                        title: 'Boosting Your Sales: In-Store & Social Promotions',
                        color: Colors.pinkAccent,
                        content: [
                          'Want to get more eyes on your art? We’ve made it incredibly easy to "Boost" your products through our promotional engine.',
                          'Paid Customer Promotions: Simply click "Promote" in your dashboard. You choose the duration (from 1 to 7 days).',
                          'The "Best Offers" Front Page: This is the most prime real estate on our app. To keep it exclusive, we only allow 30 items here at a time.',
                          'Max 3 Days: Items stay in the "Best Offers" section for a maximum of 3 days to keep the page fresh.',
                          'Social Media Power: For promotions longer than 3 days, we extend your reach to our official TikTok and Facebook pages.',
                          'Full Analytics: We don\'t just promote and hope for the best. We send you the analytics showing exactly where we promoted your product and how it performed.'
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Newest-First Advantage
                      _rainbowSection(
                        title: 'The "Newest-First" Advantage',
                        color: Colors.blueAccent,
                        content: [
                          'Our app is designed to reward active artists. We use a "Newest-First" logic across the entire store.',
                          'Automatic Home Page Entry: The moment your new product is accepted, it is automatically featured on the Home Page.',
                          'Visibility Duration: Your item stays at the top until newer products are loaded. Depending on the day, this could be anywhere from 1 hour to 5 days.',
                          'Social Media Integration: New products also appear on our social media automatically as they are loaded, giving you free "Day One" exposure!'
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // 9. The "Star Creator" Program: Celebrating Your Success
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  width: 3,
                  style: BorderStyle.solid,
                  color: Colors.transparent,
                ),
                gradient: null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    width: 3,
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE040FB), // pink-purple
                      Color(0xFF7C4DFF), // purple
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFFE040FB),
                                Color(0xFF7C4DFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            '9. The "Star Creator" Program: Celebrating Your Success',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'CherryCreamSoda',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // masked by shader
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'At Spoil Me Vintage, we believe that artists who consistently provide high-quality items and reach high sales volumes deserve to be celebrated. Our Star Creator Program is an exclusive tier for our most successful partners—the creators who help keep our 7,000+ monthly customers coming back for more.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'How it Works:',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE040FB),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...[
                        'We automatically track your sales performance and customer satisfaction.',
                        'When you hit our "Top-Tier" milestones, you unlock premium benefits designed to explode your brand’s reach:',
                        'Priority "Best Offers" Placement: Star Creators get "first-look" priority for the Front Page Best Offers section. When you have new stock, we make sure it’s the first thing our high-spending customers see.',
                        'The "Star Creator" Badge: Your store profile and every one of your product listings will receive an exclusive Star Creator Badge. In a marketplace of thousands, this badge acts as a "Seal of Trust," telling shoppers that you are a top-rated, reliable, and beloved artist.',
                        'Enhanced Social Media Spotlights: Our marketing team goes beyond standard posts for our Star Creators. We produce dedicated "Artist Spotlight" features for our TikTok and Facebook pages, sharing your story, your process, and your art with our entire social community.',
                        'Early Access to New Features: Spoil Me Vintage is always evolving. Star Creators are invited to "Beta Test" our newest app features and promotional tools before they are released to the general community, giving you a competitive edge.',
                        'Dedicated Growth Support: You gain a direct line to our Hub management team for personalized advice on inventory and trends to help you stay at the top of the leaderboards.',
                      ].map((line) {
                        final idx = line.indexOf(':');
                        if (idx > 0) {
                          final label = '${line.substring(0, idx + 1)} ';
                          final value = line.substring(idx + 1);
                          final wordCount = label.replaceAll(':', '').trim().split(RegExp(r'\\s+')).length;
                          final isShortLabel = wordCount >= 1 && wordCount <= 4;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: label,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE040FB),
                                      fontSize: isShortLabel ? 16 : 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: value,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          );
                        }
                      }) // closes map and converts to list
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Here's Why It Works section
            Container(
              width: questionCardWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF00B0FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00B0FF).withValues(alpha: (0.4 * 255)),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Here\'s Why It Works',
                      style: TextStyle(
                        fontFamily: 'CherryCreamSoda',
                        fontSize: 16,
                        color: Color(0xFF00B0FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We believe in transparency, security, and partnership. Here’s how we ensure your success:',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.white, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  // Bullet points for each reason
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint('Fast, reliable delivery from our Worcester Hub.'),
                      _buildBulletPoint('Your art is protected with our "Peace of Mind" guarantee.'),
                      _buildBulletPoint('You keep 97% of the profit from each sale.'),
                      _buildBulletPoint('Transparent pricing and fees, no hidden costs.'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 2025 Analytics button
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Here is 2025 Analytics – Decide for Yourself',
                          style: TextStyle(
                            fontFamily: 'CherryCreamSoda',
                            fontSize: 15,
                            color: Color(0xFF00B0FF),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: Color(0xFF00B0FF), width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF00B0FF).withValues(alpha: (0.4 * 255)),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/yearly_analytic_2025.png',
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context).size.width * 0.8,
                                          ),
                                          const SizedBox(height: 10),
                                          OutlinedButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              side: BorderSide(color: Color(0xFF00B0FF), width: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'IndieFlower',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Color(0xFF00B0FF), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00B0FF).withValues(alpha: (0.4 * 255)),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/yearly_analytic_2025.png',
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 80,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Click to view full analytics',
                                  style: TextStyle(
                                    fontFamily: 'IndieFlower',
                                    fontSize: 12,
                                    color: Color(0xFF00B0FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Ready to start? section moved here as a button
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showExplore = false;
                          // Set a flag or state to show the new Step 2 title
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Color(0xFF00B0FF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                      ),
                      child: const Text(
                        'Choose Your Store Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IndieFlower',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandPackages() {
    final packages = [
      {
        'title': 'Tester',
        'price': 'R19/month',
        'details': '5 Product Slots • Basic Support',
        'spots': '45 / 50 spots taken',
        'locked': false,
        'mostPopular': false,
      },
      {
        'title': 'Hobbyist',
        'price': 'R49/month',
        'details': '20 Product Slots • Email Support',
        'spots': '46 / 50 spots taken',
        'locked': false,
        'mostPopular': false,
      },
      {
        'title': 'Creator',
        'price': 'R99/month',
        'details': '50 Product Slots • Priority Support • Access to Analytics',
        'spots': '46 / 50 spots taken',
        'locked': false,
        'mostPopular': true,
      },
      {
        'title': 'Boutique',
        'price': 'R189/month',
        'details': '100 Product Slots • Dedicated Support • Advanced Analytics',
        'spots': 'LOCKED Requires 100+ sales to unlock',
        'locked': true,
        'mostPopular': false,
      },
      {
        'title': 'Gallery',
        'price': 'R399/month',
        'details': '250 Product Slots • 24/7 Support • Full Analytics Suite',
        'spots': 'LOCKED Invitation Only',
        'locked': true,
        'mostPopular': false,
      },
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          // Step 2 - Choose Your Store Package section (title updated after "Ready to start?" click)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Color(0xFFE040FB), width: 2), // pink-purple border
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: (0.2 * 255)),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFFE040FB),
                              Color(0xFF7C4DFF),
                              Color(0xFF00B0FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Choose Your Store Package',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'CherryCreamSoda',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // masked by shader
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We advice to start on the smallest package and when you find this platform something you like upgrade.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'IndieFlower',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.arrow_downward, size: 32, color: Color(0xFFE040FB)),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65, // Make card taller to fix overflow
            ),
            itemCount: packages.length,
            itemBuilder: (context, i) {
              final pkg = packages[i];
              final String title = pkg['title'] as String;
              final String price = pkg['price'] as String;
              final String details = pkg['details'] as String;
              final String spots = pkg['spots'] as String;
              final bool locked = pkg['locked'] as bool;
              final bool mostPopular = pkg['mostPopular'] as bool;
              // Color and style per card
              Color borderColor;
              Color shadowColor;
              Color bulletColor;
              Color titleColor;
              switch (title) {
                case 'Tester':
                  borderColor = Colors.cyanAccent;
                  shadowColor = Colors.cyanAccent.withValues(alpha: (0.7 * 255));
                  bulletColor = Colors.cyanAccent;
                  titleColor = Color(0xFF00B0FF); // blue
                  break;
                case 'Hobbyist':
                  borderColor = Color(0xFF0D47A1); // dark blue
                  shadowColor = const Color(0xFF1976D2).withValues(alpha: (0.7 * 255)); // blue shadow
                  bulletColor = const Color(0xFF1976D2);
                  titleColor = Color(0xFF1976D2); // dark blue
                  break;
                case 'Creator':
                  borderColor = const Color(0xFF8E24AA); // purple
                  shadowColor = const Color(0xFFBA68C8).withValues(alpha: (0.7 * 255)); // purple shadow
                  bulletColor = const Color(0xFFBA68C8);
                  titleColor = Color(0xFFBA68C8); // light purple
                  break;
                case 'Boutique':
                  borderColor = const Color(0xFFD81B60); // dark pink
                  shadowColor = const Color(0xFFF06292).withValues(alpha: (0.7 * 255)); // pink shadow
                  bulletColor = const Color(0xFFF06292);
                  titleColor = Color(0xFFF06292); // light pink
                  break;
                case 'Gallery':
                  borderColor = Color(0xFF43A047); // green (will be replaced)
                  shadowColor = Color(0xFF8BC34A).withValues(alpha: (0.7 * 255)); // light green shadow
                  bulletColor = Color(0xFF8BC34A); // light green
                  titleColor = Color(0xFF8BC34A); // light green
                  break;
                default:
                  borderColor = Colors.white;
                  shadowColor = Colors.white.withAlpha((0.15 * 255).toInt());
                  bulletColor = Colors.white;
                  titleColor = Colors.white;
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 0), // all around
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Banner for Creator
                      if (mostPopular)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF8E24AA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'MOST POPULAR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'CherryCreamSoda',
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Price
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16), // Large space after price for all cards
                      // Spots (only for unlocked)
                      if (!locked)
                        Text(
                          spots,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!locked) const SizedBox(height: 16), // Larger space between spots and details
                      // Details (slots) as bullet points
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final point in details.split('•'))
                            if (point.trim().isNotEmpty)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ', style: TextStyle(fontSize: 13, color: bulletColor, fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(point.trim(), style: const TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold))),
                                ],
                              ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Join button at the bottom
                      if (!locked)
                        Padding(
                          padding: EdgeInsets.only(top: (title == 'Tester' || title == 'Hobbyist') ? 4 : 16), // Reduce gap for Tester/Hobbyist
                          child: SizedBox(
                            width: 80,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.black,
                                side: BorderSide(color: borderColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                                shadowColor: borderColor,
                                elevation: 8,
                              ),
                              onPressed: () { _showJoinDialog(); },
                              child: Text(
                                'Join',
                                style: TextStyle(
                                  fontFamily: 'IndieFlower',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(color: borderColor.withValues(alpha: (0.7 * 255)), blurRadius: 8, offset: Offset(0, 2))],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (locked)
                        const SizedBox(height: 16),
                      if (locked)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black,
                              side: BorderSide(color: borderColor, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                            ),
                            child: Builder(
                              builder: (context) {
                                if (title == 'Boutique') {
                                  return Column(
                                    children: [
                                      Text('🔒', style: TextStyle(fontSize: 24, color: Color(0xFFF06292))), // light pink lock
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Requires 100+ sales',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (title == 'Gallery') {
                                  return Column(
                                    children: [
                                      Text('🔒', style: TextStyle(fontSize: 24, color: Color(0xFF8BC34A))), // light green lock only
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Invitation Only',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    spots,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ), // End of Container
              ); // End of itemBuilder
            }, // End of GridView.builder
          ),
        ], // End of children in Column
      ), // End of Column
    ); // End of SingleChildScrollView
  }

  // Helper function for launching URLs
  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      children: [
        Text('• ', style: TextStyle(fontSize: 13, color: Color(0xFF00B0FF), fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.white, height: 1.4),
          ),
        ),
      ],
    );
  }

  // Helper for label:value with color and bold label
  Widget _labelValueColor(String text, Color color) {
    final idx = text.indexOf(':');
    if (idx > 0) {
      final label = '${text.substring(0, idx + 1)} ';
      final value = text.substring(idx + 1);
      // Count words in label (split by space, ignore trailing colon)
      final wordCount = label.replaceAll(':', '').trim().split(RegExp(r'\\s+')).length;
      final isShortLabel = wordCount >= 1 && wordCount <= 4;
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: isShortLabel ? 16 : 14, // One size larger for 1-4 word labels
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        text,
        style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 13),
      );
    }
  }

  // Helper for rainbow section
  Widget _rainbowSection({required String title, required Color color, required List<String> content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        // Remove border and shadow for inner cards in section 8
        // No border, no boxShadow
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'CherryCreamSoda',
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          ...content.map((c) {
            final idx = c.indexOf(':');
            if (idx > 0) {
              final label = '${c.substring(0, idx + 1)} ';
              final value = c.substring(idx + 1);
              final wordCount = label.replaceAll(':', '').trim().split(RegExp(r'\\s+')).length;
              final isShortLabel = wordCount >= 1 && wordCount <= 4;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: isShortLabel ? 16 : 14, // One size larger for 1-4 word labels
                        ),
                      ),
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 12, // One size smaller
                          fontWeight: FontWeight.normal, // Not bold
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  c,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          }) // closes map and converts to list
        ],
      ),
    );
  }
} // End of _ArtistDashboardScreenState
