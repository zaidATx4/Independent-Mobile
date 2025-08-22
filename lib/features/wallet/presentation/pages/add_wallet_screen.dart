import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key});

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  final _walletNameController = TextEditingController();
  final _spendingLimitController = TextEditingController();
  final _resetDateController = TextEditingController();
  
  String _selectedAmount = '1000';
  String _selectedPeriod = 'Monthly';
  bool _spendingLimitEnabled = true;

  @override
  void dispose() {
    _walletNameController.dispose();
    _spendingLimitController.dispose();
    _resetDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildHeader(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildWalletNameSection(),
                  const SizedBox(height: 32),
                  _buildWalletAmountSection(),
                  const SizedBox(height: 32),
                  _buildRenewalPeriodSection(),
                  const SizedBox(height: 32),
                  _buildResetDateSection(),
                  const SizedBox(height: 32),
                  _buildSpendingLimitSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _circleButton(
            onTap: () => context.pop(),
            border: true,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFFFEFEFF),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Add Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFEFEFF),
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required VoidCallback onTap,
    required Widget child,
    bool border = false,
    Color? fill,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill ?? Colors.transparent,
        border: border
            ? Border.all(color: const Color(0xFFFEFEFF), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildWalletNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wallet Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFF),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _walletNameController,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFFEFEFF),
          ),
          decoration: InputDecoration(
            hintText: 'Enter wallet name',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0x80FEFEFF),
            ),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFFFBF1), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletAmountSection() {
    final amounts = ['250', '500', '750', '1000'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wallet Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFF),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: amounts.map((amount) {
            final isSelected = _selectedAmount == amount;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: amount != amounts.last ? 12 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedAmount = amount),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFFFBF1) : const Color(0xFFFEFEFF),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$amount ﷼',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? const Color(0xFF242424) : const Color(0xFFFEFEFF),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRenewalPeriodSection() {
    final periods = ['Weekly', 'Monthly'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renewal Period',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFF),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: periods.map((period) {
            final isSelected = _selectedPeriod == period;
            return Padding(
              padding: EdgeInsets.only(right: period != periods.last ? 12 : 0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedPeriod = period),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFFBF1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFFFBF1) : const Color(0xFFFEFEFF),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF242424) : const Color(0xFFFEFEFF),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResetDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reset Day',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFF),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _resetDateController,
          readOnly: true,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFFEFEFF),
          ),
          decoration: InputDecoration(
            hintText: 'Reset renewal date',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0x80FEFEFF),
            ),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFFFFBF1), width: 1),
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.calendar_today,
                color: Color(0xFFFEFEFF),
                size: 20,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          onTap: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildSpendingLimitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Spending Limit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFEFEFF),
              ),
            ),
            _buildCustomSwitch(),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Set your own spending limit based on your preferences and budget control needs.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xCCFEFEFF),
          ),
        ),
        if (_spendingLimitEnabled) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _spendingLimitController,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFEFEFF),
            ),
            decoration: InputDecoration(
              hintText: 'Set spending limit',
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color(0x80FEFEFF),
              ),
              filled: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Color(0xFFFEFEFF), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Color(0xFFFFFBF1), width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 28 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFFBF1),
            foregroundColor: const Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            // Navigate to payment options screen
            context.push('/wallet/payment-options');
          },
          child: const Text('Next'),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch() {
    return GestureDetector(
      onTap: () => setState(() => _spendingLimitEnabled = !_spendingLimitEnabled),
      child: Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _spendingLimitEnabled 
              ? const Color(0xFFFFFBF1) // Background when selected (#FFFBF1)
              : const Color(0xFF9C9C9D), // Background when not selected (#9C9C9D)
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _spendingLimitEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _spendingLimitEnabled 
                  ? const Color(0xFF1E1E1E) // Dot color when selected
                  : const Color(0xFF1A1A1A), // Dot color when not selected
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFFBF1),
              onPrimary: Color(0xFF242424),
              surface: Color(0xFF2A2A2A),
              onSurface: Color(0xFFFEFEFF),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _resetDateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }
}