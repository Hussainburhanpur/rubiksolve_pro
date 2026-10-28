import 'package:flutter/material.dart';
import 'beginner_tutorial_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final algorithms = [
      const AlgorithmData(
        name: 'Beginner Method',
        description:
            'Learn the classic step-by-step method for solving a cube.',
        level: 'Beginner',
        icon: Icons.school_outlined,
        overview:
            'The Beginner Method is designed to teach the fundamental '
            'concepts of solving a Rubik\'s Cube without requiring a large '
            'set of algorithms.',
        stages: [
          'Make the first cross',
          'Solve the first-layer corners',
          'Solve the middle-layer edges',
          'Make the last-layer cross',
          'Orient the last-layer corners',
          'Position the last-layer pieces',
        ],
        advantages: [
          'Easy to learn',
          'Good for first-time cubers',
          'Builds a strong understanding of cube notation',
          'Provides the foundation for advanced methods',
        ],
      ),
      const AlgorithmData(
        name: 'CFOP',
        description:
            'A popular speedcubing method using Cross, F2L, OLL and PLL.',
        level: 'Intermediate',
        icon: Icons.speed_outlined,
        overview:
            'CFOP is one of the most widely used speedsolving methods. '
            'It divides the solve into four major stages and is designed '
            'to reduce solve time through efficient algorithms and lookahead.',
        stages: [
          'Cross',
          'First Two Layers (F2L)',
          'Orientation of the Last Layer (OLL)',
          'Permutation of the Last Layer (PLL)',
        ],
        advantages: [
          'Excellent for speedsolving',
          'Large amount of learning material available',
          'Structured solving process',
          'Scales well from beginner to advanced cubing',
        ],
      ),
      const AlgorithmData(
        name: 'Roux',
        description:
            'A block-building method focused on efficiency and fewer moves.',
        level: 'Advanced',
        icon: Icons.view_in_ar_outlined,
        overview:
            'Roux is a block-building solving method. Instead of building '
            'layers, the solver creates blocks on opposite sides and then '
            'solves the remaining pieces efficiently.',
        stages: [
          'Build the first 1×2×3 block',
          'Build the second 1×2×3 block',
          'Solve the remaining corners',
          'Solve the remaining edges using M-slice moves',
        ],
        advantages: [
          'Low move count',
          'Efficient block building',
          'Uses fewer rotations',
          'Strong focus on lookahead and efficiency',
        ],
      ),
      const AlgorithmData(
        name: 'ZZ Method',
        description:
            'An orientation-first method designed for efficient solving.',
        level: 'Advanced',
        icon: Icons.auto_awesome_outlined,
        overview:
            'ZZ begins by orienting all edges. Once edge orientation is '
            'established, the rest of the solve can be performed with '
            'efficient block-building and last-layer techniques.',
        stages: [
          'Edge Orientation (EO)',
          'Build the first two layers',
          'Solve the remaining last-layer pieces',
        ],
        advantages: [
          'Reduces cube rotations',
          'Strong focus on orientation',
          'Efficient turning during the solve',
          'Can combine well with advanced last-layer techniques',
        ],
      ),
      const AlgorithmData(
        name: 'Kociemba Algorithm',
        description:
            'A two-phase algorithm used by RubikSolve to find efficient solutions.',
        level: 'Advanced',
        icon: Icons.memory_outlined,
        overview:
            'Kociemba\'s two-phase algorithm searches for a solution by '
            'breaking the problem into two stages. RubikSolve uses this '
            'algorithm through the Kociemba solver on its backend.',
        stages: [
          'Phase 1: Reduce the cube into a restricted subgroup',
          'Phase 2: Solve the cube from that subgroup',
          'Search for an efficient solution',
          'Return the resulting move sequence',
        ],
        advantages: [
          'Produces short solutions',
          'Much faster than searching the entire cube space directly',
          'Well suited for computer-based cube solving',
          'Used by RubikSolve\'s solving engine',
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn Algorithms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.22),
                  theme.colorScheme.secondary.withValues(alpha: 0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: theme.colorScheme.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master the Cube',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Understand the methods behind every solution.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Solving Methods',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...algorithms.map(
            (algorithm) => _AlgorithmCard(
              algorithm: algorithm,
            ),
          ),
        ],
      ),
    );
  }
}

class AlgorithmData {
  const AlgorithmData({
    required this.name,
    required this.description,
    required this.level,
    required this.icon,
    required this.overview,
    required this.stages,
    required this.advantages,
  });

  final String name;
  final String description;
  final String level;
  final IconData icon;
  final String overview;
  final List<String> stages;
  final List<String> advantages;
}

class _AlgorithmCard extends StatelessWidget {
  const _AlgorithmCard({
    required this.algorithm,
  });

  final AlgorithmData algorithm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
  if (algorithm.name == 'Beginner Method') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BeginnerTutorialScreen(),
      ),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AlgorithmDetailScreen(
        algorithm: algorithm,
      ),
    ),
  );
},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  algorithm.icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            algorithm.name,
                            style:
                                theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _LevelBadge(level: algorithm.level),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      algorithm.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.35,
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({
    required this.level,
  });

  final String level;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class AlgorithmDetailScreen extends StatelessWidget {
  const AlgorithmDetailScreen({
    super.key,
    required this.algorithm,
  });

  final AlgorithmData algorithm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          algorithm.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              border: Border.all(
                color:
                    theme.colorScheme.primary.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    algorithm.icon,
                    size: 34,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  algorithm.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _LevelBadge(level: algorithm.level),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _Section(
            title: 'Overview',
            child: Text(
              algorithm.overview,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: theme.textTheme.bodyLarge?.color
                    ?.withValues(alpha: 0.8),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _Section(
            title: 'How It Works',
            child: Column(
              children: [
                for (int i = 0; i < algorithm.stages.length; i++)
                  _StageItem(
                    number: i + 1,
                    text: algorithm.stages[i],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _Section(
            title: 'Why Learn It?',
            child: Column(
              children: algorithm.advantages
                  .map(
                    (advantage) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              advantage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _StageItem extends StatelessWidget {
  const _StageItem({
    required this.number,
    required this.text,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}