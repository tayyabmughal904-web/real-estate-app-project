import 'package:flutter/material.dart';
import '../models/agent_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'property_detail_screen.dart';
import 'chat_detail_screen.dart';

class AgentDetailScreen extends StatelessWidget {
  final Agent agent;

  const AgentDetailScreen({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final agentProperties = appState.properties.where((p) => p.agent.id == agent.id || p.agent.name == agent.name).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkScaffoldBg : AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('Agent Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Agent profile link copied: luxeylin.com/agents/${agent.id}')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Profile Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: cardBg,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppTheme.primaryLight,
                        backgroundImage: agent.avatarUrl.isNotEmpty ? NetworkImage(agent.avatarUrl) : null,
                        child: agent.avatarUrl.isEmpty
                            ? const Icon(Icons.person, size: 50, color: AppTheme.primaryColor)
                            : null,
                      ),
                      if (agent.isVerified)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified, color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    agent.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agent.agency,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${agent.licenseNumber} • ${agent.yearsExperience} Years Experience',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Rating', '⭐ ${agent.rating}', textPrimary, textSecondary),
                      Container(height: 30, width: 1, color: border),
                      _buildStatItem('Reviews', '${agent.reviewsCount}', textPrimary, textSecondary),
                      Container(height: 30, width: 1, color: border),
                      _buildStatItem('Listings', '${agentProperties.isNotEmpty ? agentProperties.length : agent.listingsCount}', textPrimary, textSecondary),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                          label: const Text('Message'),
                          onPressed: () {
                            final conv = appState.getOrCreateConversationForAgent(agent);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => ChatDetailScreen(conversation: conv),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.phone_rounded, size: 18),
                        label: const Text('Call'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling ${agent.name} (${agent.phone})...')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(12)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email client opening for ${agent.email}...')),
                          );
                        },
                        child: const Icon(Icons.email_outlined, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // About Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About ${agent.name}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    agent.about.isNotEmpty
                        ? agent.about
                        : 'Dedicated real estate professional specialized in luxury residences, architectural estates, and investment properties with high attention to client discretion.',
                    style: TextStyle(fontSize: 13.5, color: textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Active Listings
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: cardBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Listings (${agentProperties.length})',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (agentProperties.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('No active listings currently.', style: TextStyle(color: textSecondary)),
                    )
                  else
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: agentProperties.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, idx) {
                          final prop = agentProperties[idx];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => PropertyDetailScreen(property: prop),
                                ),
                              );
                            },
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                    child: SizedBox(
                                      height: 110,
                                      width: double.infinity,
                                      child: prop.images.isNotEmpty
                                          ? (prop.images.first.startsWith('assets/')
                                              ? Image.asset(prop.images.first, fit: BoxFit.cover)
                                              : Image.network(prop.images.first, fit: BoxFit.cover))
                                          : Container(color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prop.formattedPrice + prop.priceSuffix,
                                          style: const TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          prop.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${prop.bedrooms} beds • ${prop.bathrooms} baths',
                                          style: TextStyle(fontSize: 11, color: textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  Widget _buildStatItem(String label, String value, Color textPrimary, Color textSecondary) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}
