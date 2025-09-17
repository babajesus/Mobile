import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/achievement_model.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTab = 'Regional';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _getTabName(_tabController.index);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Regional';
      case 1:
        return 'State';
      case 2:
        return 'National';
      default:
        return 'Regional';
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(leaderboardProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Regional'),
            Tab(text: 'State'),
            Tab(text: 'National'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(leaderboard, user, 'Regional'),
          _buildLeaderboardTab(leaderboard, user, 'State'),
          _buildLeaderboardTab(leaderboard, user, 'National'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(List<LeaderboardEntry> leaderboard, user, String level) {
    // Filter leaderboard based on level
    final filteredLeaderboard = _filterLeaderboard(leaderboard, level);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header stats
          _buildHeaderStats(filteredLeaderboard, user),
          
          const SizedBox(height: 24),
          
          // Top 3 podium
          if (filteredLeaderboard.isNotEmpty)
            _buildPodium(filteredLeaderboard),
          
          const SizedBox(height: 24),
          
          // Full leaderboard
          _buildFullLeaderboard(filteredLeaderboard, user),
        ],
      ),
    );
  }

  Widget _buildHeaderStats(List<LeaderboardEntry> leaderboard, user) {
    final userRank = leaderboard.indexWhere((entry) => entry.userId == user?.id) + 1;
    final totalParticipants = leaderboard.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rank',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userRank > 0 ? '#$userRank' : 'Unranked',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Participants',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalParticipants',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> leaderboard) {
    final topThree = leaderboard.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Top Performers',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 2nd place
              if (topThree.length > 1)
                _buildPodiumItem(topThree[1], 2, false),
              
              // 1st place
              if (topThree.isNotEmpty)
                _buildPodiumItem(topThree[0], 1, true),
              
              // 3rd place
              if (topThree.length > 2)
                _buildPodiumItem(topThree[2], 3, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, int rank, bool isFirst) {
    final colors = [
      AppColors.warning, // Gold
      AppColors.textSecondary, // Silver
      AppColors.error, // Bronze
    ];
    
    return Column(
      children: [
        // Profile picture and rank
        Stack(
          children: [
            CircleAvatar(
              radius: isFirst ? 35 : 30,
              backgroundColor: colors[rank - 1].withOpacity(0.1),
              backgroundImage: entry.profilePicturePath != null
                  ? NetworkImage(entry.profilePicturePath!)
                  : null,
              child: entry.profilePicturePath == null
                  ? Icon(
                      Icons.person,
                      size: isFirst ? 35 : 30,
                      color: colors[rank - 1],
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors[rank - 1],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Name and score
        Text(
          entry.name,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          '${entry.score.toStringAsFixed(1)} pts',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          entry.region,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFullLeaderboard(List<LeaderboardEntry> leaderboard, user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Leaderboard',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          if (leaderboard.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.leaderboard_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No data available',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete some tests to appear on the leaderboard',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...leaderboard.asMap().entries.map((entry) {
              final index = entry.key;
              final leaderboardEntry = entry.value;
              final isCurrentUser = leaderboardEntry.userId == user?.id;
              
              return _buildLeaderboardItem(
                leaderboardEntry,
                index + 1,
                isCurrentUser,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, int rank, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: rank > 99 ? 10 : 14,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Profile picture
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            backgroundImage: entry.profilePicturePath != null
                ? NetworkImage(entry.profilePicturePath!)
                : null,
            child: entry.profilePicturePath == null
                ? Icon(
                    Icons.person,
                    size: 20,
                    color: AppTheme.primaryColor,
                  )
                : null,
          ),
          
          const SizedBox(width: 12),
          
          // Name and region
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
                    color: isCurrentUser ? AppTheme.primaryColor : AppColors.textPrimary,
                  ),
                ),
                Text(
                  entry.region,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score.toStringAsFixed(1)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isCurrentUser ? AppTheme.primaryColor : AppColors.textPrimary,
                ),
              ),
              Text(
                'points',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<LeaderboardEntry> _filterLeaderboard(List<LeaderboardEntry> leaderboard, String level) {
    // Mock filtering based on level
    switch (level) {
      case 'Regional':
        return leaderboard.where((entry) => entry.region == 'Delhi').toList();
      case 'State':
        return leaderboard.where((entry) => 
          ['Delhi', 'Mumbai', 'Bangalore'].contains(entry.region)).toList();
      case 'National':
        return leaderboard;
      default:
        return leaderboard;
    }
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return AppColors.warning; // Gold
    if (rank == 2) return AppColors.textSecondary; // Silver
    if (rank == 3) return AppColors.error; // Bronze
    return AppTheme.primaryColor; // Default
  }
}
