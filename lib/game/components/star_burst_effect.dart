import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class StarBurstEffect extends ParticleSystemComponent {
  StarBurstEffect({
    required Vector2 position,
    required Color color,
  }) : super(
          particle: _buildBurst(color),
          position: position,
        );

  static Particle _buildBurst(Color color) {
    const int count = 12;
    const double lifetime = 0.6;
    final rng = Random();

    return ComposedParticle(
      lifespan: lifetime,
      children: List.generate(count, (i) {
        final angle = (2 * pi * i) / count;
        final speed = 40.0 + rng.nextDouble() * 60.0;
        return AcceleratedParticle(
          lifespan: lifetime,
          acceleration: Vector2(0, 80),
          speed: Vector2(cos(angle) * speed, sin(angle) * speed),
          child: CircleParticle(
            radius: 2.5,
            paint: Paint()..color = color,
          ),
        );
      }),
    );
  }
}
