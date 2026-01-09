import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pms/core/constants/app_colors.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:pms/features/fees/data/models/fee_model.dart';
import 'package:pms/features/fees/presentation/providers/fee_provider.dart';
import 'package:pms/shared/widgets/feedback/loading_indicator.dart';
import 'package:pms/shared/widgets/feedback/empty_state_widget.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childId = context.read<DashboardProvider>().selectedChild?.id;
      if (childId != null) {
        context.read<FeeProvider>().loadFees(childId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fee Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Payment History'),
            ],
          ),
        ),
        body: Consumer<FeeProvider>(
          builder: (context, feeProvider, _) {
            if (feeProvider.isLoading) {
              return const LoadingIndicator(message: 'Loading fees...');
            }

            if (feeProvider.errorMessage != null) {
              return EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Error',
                message: feeProvider.errorMessage!,
                actionButtonText: 'Retry',
                onActionPressed: () {
                  final childId = context.read<DashboardProvider>().selectedChild?.id;
                  if (childId != null) {
                    feeProvider.loadFees(childId);
                  }
                },
              );
            }

            return Column(
              children: [
                _buildFeeSummary(feeProvider),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildFeeList(context, feeProvider.pendingFees),
                      _buildFeeList(context, feeProvider.paidFees, isHistory: true),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Open payment gateway or manual payment entry
          },
          label: const Text('Quick Pay'),
          icon: const Icon(Icons.payment),
        ),
      ),
    );
  }

  Widget _buildFeeSummary(FeeProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          _buildSummaryItem(
            'Total Pending',
            '₨${provider.totalPendingAmount.toStringAsFixed(0)}',
            AppColors.lightError,
          ),
          const VerticalDivider(),
          _buildSummaryItem(
            'Total Paid',
            '₨${provider.totalPaidAmount.toStringAsFixed(0)}',
            AppColors.lightSuccess,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeList(BuildContext context, List<FeeModel> fees, {bool isHistory = false}) {
    if (fees.isEmpty) {
      return EmptyStateWidget(
        icon: isHistory ? Icons.history : Icons.account_balance_wallet_outlined,
        title: isHistory ? 'No History' : 'All Settled!',
        message: isHistory 
            ? 'You haven\'t made any payments yet.' 
            : 'No pending fees found for the selected child.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.medium),
      itemCount: fees.length,
      itemBuilder: (context, index) {
        return _buildFeeCard(fees[index]);
      },
    );
  }

  Widget _buildFeeCard(FeeModel fee) {
    bool isOverdue = fee.status == FeeStatus.overdue;
    bool isPaid = fee.status == FeeStatus.paid;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.medium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(fee.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    fee.status.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(fee.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  fee.formattedDueDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverdue ? AppColors.lightError : null,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.medium),
            Text(
              fee.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (fee.description != null) ...[
              const SizedBox(height: 4),
              Text(
                fee.description!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppTheme.medium),
            const Divider(),
            const SizedBox(height: AppTheme.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '₨${fee.amount.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (!isPaid)
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to payment
                    },
                    child: const Text('Pay Now'),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.download_for_offline_outlined),
                    onPressed: () {
                      // TODO: Download invoice PDF
                    },
                    tooltip: 'Download Invoice',
                  ),
              ],
            ),
            if (isPaid && fee.transactionId != null) ...[
              const SizedBox(height: AppTheme.small),
              Text(
                'Paid on: ${fee.formattedPaymentDate}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'TXN: ${fee.transactionId}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(FeeStatus status) {
    switch (status) {
      case FeeStatus.paid:
        return AppColors.lightSuccess;
      case FeeStatus.pending:
        return AppColors.lightInfo;
      case FeeStatus.overdue:
        return AppColors.lightError;
      case FeeStatus.partiallyPaid:
        return AppColors.lightWarning;
    }
  }
}
