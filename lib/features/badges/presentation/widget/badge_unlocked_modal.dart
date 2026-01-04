import 'package:flutter/material.dart';

class BadgeUnlockedModal extends StatefulWidget {
  final String title;
  final String message;
  final String iconUrl; // network url
  final VoidCallback onContinue;
  final VoidCallback onViewBadges;
  final bool earned;

  const BadgeUnlockedModal({
    super.key,
    required this.title,
    required this.message,
    required this.iconUrl,
    required this.onContinue,
    required this.onViewBadges,
    required this.earned,
  });

  @override
  State<BadgeUnlockedModal> createState() => _BadgeUnlockedModalState();
}

class _BadgeUnlockedModalState extends State<BadgeUnlockedModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _badgeScale;
  late final Animation<double> _checkScale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _badgeScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _checkScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _glow = Tween(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width > 420 ? 420.0 : width * 0.92;

    return SafeArea(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBadgeIcon(
                        iconUrl: widget.iconUrl,
                        glow: _glow,
                        badgeScale: _badgeScale,
                        checkScale: _checkScale,
                        earned: widget.earned,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.earned ? 'BADGE UNLOCKED' : 'BADGE DETAILS',
                        style: const TextStyle(
                          letterSpacing: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B417A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: widget.onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B417A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onViewBadges,
                        child: const Text(
                          'View my badges',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*class BadgeUnlockedModal extends StatefulWidget {
  final String title;
  final String message;
  final String iconUrl; //  network url
  final VoidCallback onContinue;
  final VoidCallback onViewBadges;
  final bool earned;

  const BadgeUnlockedModal(
      {super.key,
      required this.title,
      required this.message,
      required this.iconUrl,
      required this.onContinue,
      required this.onViewBadges,
      required this.earned});

  @override
  State<BadgeUnlockedModal> createState() => _BadgeUnlockedModalState();
}

class _BadgeUnlockedModalState extends State<BadgeUnlockedModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _badgeScale;
  late final Animation<double> _checkScale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _badgeScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _checkScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _glow = Tween(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width > 420 ? 420.0 : width * 0.92;

    return SafeArea(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBadgeIcon(
                        iconUrl: widget.iconUrl,
                        glow: _glow,
                        badgeScale: _badgeScale,
                        checkScale: _checkScale,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.earned ? 'BADGE UNLOCKED' : 'BADGE DETAILS',
                        style: const TextStyle(
                          letterSpacing: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B417A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: widget.onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B417A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onViewBadges,
                        child: const Text(
                          'View my badges',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

class AnimatedBadgeIcon extends StatelessWidget {
  final String iconUrl;
  final Animation<double> glow;
  final Animation<double> badgeScale;
  final Animation<double> checkScale;
  final bool earned;

  const AnimatedBadgeIcon({
    super.key,
    required this.iconUrl,
    required this.glow,
    required this.badgeScale,
    required this.checkScale,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glow,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.scale(
              scale: glow.value,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2B417A).withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: badgeScale,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: Colors.white, width: 6),
                ),
                padding: const EdgeInsets.all(22),
                child: Image.network(
                  iconUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.verified, size: 52),
                ),
              ),
            ),

            //  sadece earned ise check göster
            if (earned)
              Positioned(
                right: 10,
                bottom: 10,
                child: ScaleTransition(
                  scale: checkScale,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2B417A),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/*class AnimatedBadgeIcon extends StatelessWidget {
  final String iconUrl;
  final Animation<double> glow;
  final Animation<double> badgeScale;
  final Animation<double> checkScale;

  const AnimatedBadgeIcon({
    super.key,
    required this.iconUrl,
    required this.glow,
    required this.badgeScale,
    required this.checkScale,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glow,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.scale(
              scale: glow.value,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2B417A).withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: badgeScale,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: Colors.white, width: 6),
                ),
                padding: const EdgeInsets.all(22),
                child: Image.network(
                  iconUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.verified, size: 52),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ScaleTransition(
                scale: checkScale,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2B417A),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}*/
