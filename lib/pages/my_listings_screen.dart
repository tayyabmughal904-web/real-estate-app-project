import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'property_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  void _showEditPriceDialog(BuildContext context, AppState appState, Property property) {
    final controller = TextEditingController(text: property.price.toStringAsFixed(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCardBg : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Asking Price', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set new price for ${property.title}:', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Price',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(controller.text.trim());
              if (newPrice != null && newPrice > 0) {
                appState.updatePropertyPrice(property.id, newPrice);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing price updated successfully!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              }
            },
            child: const Text('Save Price'),
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog(BuildContext context, AppState appState, Property property) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statuses = ['Active', 'Pending', 'Sold'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCardBg : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Listing Status', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final isCurrent = property.status == status;
            return ListTile(
              title: Text(status, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
              trailing: isCurrent ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor) : null,
              onTap: () {
                appState.updatePropertyStatus(property.id, status);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Status changed to "$status"')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppState appState, Property property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Listing'),
        content: Text('Are you sure you want to unlist "${property.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () {
              appState.deleteProperty(property.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property unlisted successfully.')),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.primaryColor;
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'sold':
        return const Color(0xFF6B7280);
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final listings = appState.myListings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkScaffoldBg : AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('My Listed Properties'),
      ),
      body: listings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.real_estate_agent_rounded, size: 50, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'No Listed Properties Yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to sell or rent your property? List your house, villa, or apartment on Luxeylin in under 3 minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5, color: textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_home_work_rounded),
                      label: const Text('List a Property Now'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/sell');
                      },
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, idx) {
                final property = listings[idx];
                final statusColor = _getStatusColor(property.status);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Image & Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 100,
                                height: 90,
                                child: property.images.isNotEmpty
                                    ? (property.images.first.startsWith('assets/')
                                        ? Image.asset(property.images.first, fit: BoxFit.cover)
                                        : Image.network(property.images.first, fit: BoxFit.cover))
                                    : Container(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        property.formattedPrice + property.priceSuffix,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          property.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    property.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${property.bedrooms} Beds • ${property.bathrooms} Baths • ${property.areaSqft.toInt()} sqft',
                                    style: TextStyle(fontSize: 11.5, color: textSecondary),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.remove_red_eye_outlined, size: 14, color: AppTheme.textLight),
                                      const SizedBox(width: 4),
                                      Text('148 Views', style: TextStyle(fontSize: 11, color: textSecondary)),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.forum_outlined, size: 14, color: AppTheme.textLight),
                                      const SizedBox(width: 4),
                                      Text('9 Inquiries', style: TextStyle(fontSize: 11, color: textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: border),

                      // Actions Strip
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit Price', style: TextStyle(fontSize: 12)),
                              onPressed: () => _showEditPriceDialog(context, appState, property),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.published_with_changes_rounded, size: 16),
                              label: const Text('Status', style: TextStyle(fontSize: 12)),
                              onPressed: () => _showChangeStatusDialog(context, appState, property),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.visibility_outlined, size: 16),
                              label: const Text('View', style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => PropertyDetailScreen(property: property),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.error, size: 18),
                              onPressed: () => _confirmDelete(context, appState, property),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
