import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class MortgageCalculatorSheet extends StatefulWidget {
  final double initialPrice;

  const MortgageCalculatorSheet({super.key, this.initialPrice = 1250000});

  static void show(BuildContext context, {double? initialPrice}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MortgageCalculatorSheet(
        initialPrice: initialPrice ?? 1250000,
      ),
    );
  }

  @override
  State<MortgageCalculatorSheet> createState() => _MortgageCalculatorSheetState();
}

class _MortgageCalculatorSheetState extends State<MortgageCalculatorSheet> {
  late double _homePrice;
  late double _downPaymentPercent; // e.g. 20%
  int _loanTermYears = 30;
  double _interestRate = 6.5; // percentage
  double _propertyTaxRate = 1.2; // annual %
  double _annualInsurance = 1400; // $ per year
  double _monthlyHoa = 250; // $ per month

  late TextEditingController _priceController;
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _homePrice = widget.initialPrice > 0 ? widget.initialPrice : 1250000;
    _downPaymentPercent = 20.0;
    _priceController = TextEditingController(text: _homePrice.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  double get _downPaymentAmount => _homePrice * (_downPaymentPercent / 100);
  double get _loanAmount => _homePrice - _downPaymentAmount;

  double get _monthlyPrincipalAndInterest {
    if (_loanAmount <= 0) return 0;
    final r = (_interestRate / 100) / 12;
    final n = _loanTermYears * 12;
    if (r == 0) return _loanAmount / n;
    final payment = _loanAmount * (r * math.pow(1 + r, n)) / (math.pow(1 + r, n) - 1);
    return payment.isNaN || payment.isInfinite ? 0 : payment;
  }

  double get _monthlyPropertyTax => (_homePrice * (_propertyTaxRate / 100)) / 12;
  double get _monthlyInsurance => _annualInsurance / 12;
  double get _totalMonthlyPayment =>
      _monthlyPrincipalAndInterest + _monthlyPropertyTax + _monthlyInsurance + _monthlyHoa;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calculate_rounded, color: AppTheme.primaryColor, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Mortgage Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Monthly Total Display Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Text(
                    'Estimated Monthly Payment',
                    style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_currencyFormat.format(_totalMonthlyPayment)}/mo',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Progress Bar Breakdown
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: math.max(1, (_monthlyPrincipalAndInterest / _totalMonthlyPayment * 100).round()),
                            child: Container(color: AppTheme.primaryColor),
                          ),
                          Expanded(
                            flex: math.max(1, (_monthlyPropertyTax / _totalMonthlyPayment * 100).round()),
                            child: Container(color: const Color(0xFFF59E0B)),
                          ),
                          Expanded(
                            flex: math.max(1, (_monthlyInsurance / _totalMonthlyPayment * 100).round()),
                            child: Container(color: const Color(0xFF38BDF8)),
                          ),
                          Expanded(
                            flex: math.max(1, (_monthlyHoa / _totalMonthlyPayment * 100).round()),
                            child: Container(color: const Color(0xFFA855F7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Legend Row
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildLegendItem('Principal & Interest', _monthlyPrincipalAndInterest, AppTheme.primaryColor, textSecondary),
                      _buildLegendItem('Property Tax', _monthlyPropertyTax, const Color(0xFFF59E0B), textSecondary),
                      _buildLegendItem('Home Insurance', _monthlyInsurance, const Color(0xFF38BDF8), textSecondary),
                      _buildLegendItem('HOA Fees', _monthlyHoa, const Color(0xFFA855F7), textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Home Price Input & Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Home Price', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
                Text(_currencyFormat.format(_homePrice), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              ],
            ),
            Slider(
              value: _homePrice.clamp(100000, 5000000),
              min: 100000,
              max: 5000000,
              divisions: 98,
              activeColor: AppTheme.primaryColor,
              onChanged: (val) {
                setState(() {
                  _homePrice = val;
                  _priceController.text = val.toStringAsFixed(0);
                });
              },
            ),
            const SizedBox(height: 12),

            // Down Payment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Down Payment', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
                Text(
                  '${_currencyFormat.format(_downPaymentAmount)} (${_downPaymentPercent.toStringAsFixed(0)}%)',
                  style: TextStyle(fontWeight: FontWeight.w600, color: textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [10, 15, 20, 25, 30].map((percent) {
                final isSelected = _downPaymentPercent.round() == percent;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? AppTheme.primaryLight : Colors.transparent,
                        side: BorderSide(color: isSelected ? AppTheme.primaryColor : border),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => setState(() => _downPaymentPercent = percent.toDouble()),
                      child: Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryColor : textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Loan Term
            Text('Loan Term', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: [15, 20, 30].map((years) {
                final isSelected = _loanTermYears == years;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? AppTheme.primaryLight : Colors.transparent,
                        side: BorderSide(color: isSelected ? AppTheme.primaryColor : border),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => setState(() => _loanTermYears = years),
                      child: Text(
                        '$years Years Fixed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryColor : textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Interest Rate Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interest Rate', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
                Text('${_interestRate.toStringAsFixed(2)}%', style: TextStyle(fontWeight: FontWeight.bold, color: textSecondary)),
              ],
            ),
            Slider(
              value: _interestRate.clamp(3.0, 12.0),
              min: 3.0,
              max: 12.0,
              divisions: 36,
              activeColor: AppTheme.primaryColor,
              onChanged: (val) => setState(() => _interestRate = val),
            ),
            const SizedBox(height: 16),

            // Pre-Approval CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.verified_user_rounded, size: 18),
                label: const Text('Get Pre-Approved with Luxeylin Lending'),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pre-approval application initialized. A mortgage advisor will connect with you.'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, double amount, Color dotColor, Color textSec) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ${_currencyFormat.format(amount)}',
          style: TextStyle(fontSize: 11, color: textSec, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
