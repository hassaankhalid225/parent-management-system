import 'package:flutter/material.dart';
import 'package:pms/core/constants/app_colors.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/shared/models/child_model.dart';

class ChildSelectorCard extends StatelessWidget {
  final ChildModel child;
  final bool isSelected;
  final VoidCallback onTap;

  const ChildSelectorCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: AppTheme.medium),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.lightPrimary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.medium),
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 40,
              backgroundColor: isSelected
                  ? Colors.white.withValues(alpha: 0.3)
                  : AppColors.lightPrimary.withValues(alpha: 0.1),
              child: child.profilePictureUrl != null
                  ? ClipOval(
                      child: Image.network(
                        child.profilePictureUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 40,
                      color: isSelected
                          ? Colors.white
                          : AppColors.lightPrimary,
                    ),
            ),

            const SizedBox(width: AppTheme.medium),

            // Child Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.fullName,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeHeading4,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.extraSmall),
                  Text(
                    child.classAndSection,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeBody2,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: AppTheme.small),
                  Wrap(
                    spacing: AppTheme.small,
                    runSpacing: AppTheme.extraSmall,
                    children: [
                      _buildStatChip(
                        context,
                        '${child.presentDays}',
                        'Present',
                        isSelected,
                      ),
                      _buildStatChip(
                        context,
                        '${child.absentDays}',
                        'Absent',
                        isSelected,
                      ),
                    ],
                  ),
                  if (child.pendingFees > 0) ...[
                    const SizedBox(height: AppTheme.small),
                    Text(
                      'Pending: ₨${child.pendingFees.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeCaption,
                        color: isSelected
                            ? Colors.white
                            : AppColors.lightWarning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String value,
    String label,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.small,
        vertical: AppTheme.extraSmall,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.2)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        '$value $label',
        style: TextStyle(
          fontSize: AppTheme.fontSizeCaption,
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
