import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class SaleItemCard extends StatelessWidget {
  final Map<String, dynamic> sale;
  final VoidCallback? onTap;
  final VoidCallback? onPrint;
  final VoidCallback? onVoid;

  const SaleItemCard({
    Key? key,
    required this.sale,
    this.onTap,
    this.onPrint,
    this.onVoid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isVoided = sale['status'] == 'voided';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isVoided ? Colors.grey.withOpacity(0.05) : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Sale Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sale['id'] ?? 'INV-000000',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isVoided ? AppColors.darkGrey : AppColors.darkText,
                              decoration: isVoided ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPaymentMethodColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPaymentMethodIcon(),
                                size: 12,
                                color: _getPaymentMethodColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getPaymentMethodLabel(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPaymentMethodColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sale['customer'] ?? 'Walk-in Customer',
                      style: TextStyle(
                        fontSize: 13,
                        color: isVoided ? AppColors.darkGrey : AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: isVoided ? AppColors.darkGrey : AppColors.darkGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDateTime(sale['date']),
                          style: TextStyle(
                            fontSize: 11,
                            color: isVoided ? AppColors.darkGrey : AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.shopping_bag,
                          size: 12,
                          color: isVoided ? AppColors.darkGrey : AppColors.darkGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${sale['items'] ?? 0} items',
                          style: TextStyle(
                            fontSize: 11,
                            color: isVoided ? AppColors.darkGrey : AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount & Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'UGX ${Helpers.formatNumber(sale['total'])}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isVoided ? AppColors.darkGrey : AppColors.primaryGreen,
                      decoration: isVoided ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (isVoided)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warningRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'VOIDED',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warningRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!isVoided && onPrint != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.print, size: 18, color: AppColors.infoBlue),
                          onPressed: onPrint,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                        if (onVoid != null)
                          IconButton(
                            icon: const Icon(Icons.cancel, size: 18, color: AppColors.warningRed),
                            onPressed: onVoid,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (sale['status']) {
      case 'completed':
        return AppColors.primaryGreen;
      case 'voided':
        return AppColors.warningRed;
      default:
        return AppColors.warningOrange;
    }
  }

  IconData _getStatusIcon() {
    switch (sale['status']) {
      case 'completed':
        return Icons.check_circle;
      case 'voided':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  Color _getPaymentMethodColor() {
    switch (sale['payment_method']) {
      case 'cash':
        return AppColors.primaryGreen;
      case 'mobile_money':
        return AppColors.warningOrange;
      case 'card':
        return AppColors.infoBlue;
      default:
        return AppColors.darkGrey;
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (sale['payment_method']) {
      case 'cash':
        return Icons.attach_money;
      case 'mobile_money':
        return Icons.phone_android;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodLabel() {
    switch (sale['payment_method']) {
      case 'cash':
        return 'CASH';
      case 'mobile_money':
        return 'MOMO';
      case 'card':
        return 'CARD';
      default:
        return sale['payment_method']?.toString().toUpperCase() ?? 'PAY';
    }
  }
}