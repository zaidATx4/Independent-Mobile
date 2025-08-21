import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Add money to wallet screen
/// Allows users to top up their wallet balance using various payment methods
class AddMoneyScreen extends ConsumerStatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  String selectedAmount = '';
  String selectedPaymentMethod = 'visa'; // Default selection
  bool isLoading = false;
  
  final List<String> quickAmounts = ['50', '100', '200', '500'];
  
  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Amount input section
                    _buildAmountSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Quick amount selection
                    _buildQuickAmountSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Payment method selection
                    _buildPaymentMethodSection(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Continue button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFEFEFF), // indpt/text primary
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFFEFEFF), // indpt/text primary
                  size: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Text(
              'Add Wallet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFFFEFEFF), // indpt/text primary
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Amount',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF2A2A2A),
            border: Border.all(
              color: const Color(0xFF4D4E52), // indpt/stroke
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Currency symbol
              SvgPicture.asset(
                'assets/images/icons/Payment_Methods/SAR.svg',
                width: 24,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFEFEFF), // indpt/text primary
                  BlendMode.srcIn,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Amount input
              Expanded(
                child: TextField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 32,
                    fontWeight: FontWeight.w600, // SemiBold
                    color: Color(0xFFFEFEFF), // indpt/text primary
                    height: 48 / 32,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9C9C9D), // indpt/text tertiary
                      height: 48 / 32,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedAmount = '';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Minimum amount: 10 SAR',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9C9C9D), // indpt/text tertiary
            height: 18 / 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Select',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quickAmounts.map((amount) => _buildQuickAmountChip(amount)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickAmountChip(String amount) {
    final isSelected = selectedAmount == amount;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        color: isSelected 
            ? const Color(0xFFFFFBF1) // indpt/sand
            : Colors.transparent,
        border: Border.all(
          color: isSelected 
              ? const Color(0xFFFFFBF1) // indpt/sand
              : const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedAmount = amount;
              _amountController.text = amount;
            });
          },
          borderRadius: BorderRadius.circular(44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium
                    color: isSelected 
                        ? const Color(0xFF242424) // indpt/accent
                        : const Color(0xFFFEFEFF), // indpt/text primary
                    height: 24 / 16,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                SvgPicture.asset(
                  'assets/images/icons/Payment_Methods/SAR.svg',
                  width: 12,
                  height: 14,
                  colorFilter: ColorFilter.mode(
                    isSelected 
                        ? const Color(0xFF242424) // indpt/accent
                        : const Color(0xFFFEFEFF), // indpt/text primary
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: Color(0xFFFEFEFF), // indpt/text primary
            height: 24 / 16,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Column(
          children: [
            _buildPaymentMethodOption(
              id: 'visa',
              title: 'Visa',
              subtitle: '**** **** **** 1234',
              iconPath: 'assets/images/icons/Payment_Methods/Visa.svg',
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethodOption(
              id: 'mastercard',
              title: 'Mastercard',
              subtitle: '**** **** **** 5678',
              iconPath: 'assets/images/icons/Payment_Methods/Mastercard.svg',
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethodOption(
              id: 'apple_pay',
              title: 'Apple Pay',
              subtitle: 'Touch ID or Face ID',
              iconPath: 'assets/images/icons/Payment_Methods/Apple_Pay.svg',
            ),
            
            const SizedBox(height: 12),
            
            _buildPaymentMethodOption(
              id: 'google_pay',
              title: 'Google Pay',
              subtitle: 'Fingerprint or PIN',
              iconPath: 'assets/images/icons/Payment_Methods/Google_Pay.svg',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required String id,
    required String title,
    required String subtitle,
    required String iconPath,
  }) {
    final isSelected = selectedPaymentMethod == id;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: isSelected 
              ? const Color(0xFFFFFBF1) // indpt/sand
              : const Color(0xFF4D4E52), // indpt/stroke
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedPaymentMethod = id;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Payment method icon
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF4D4E52).withValues(alpha: 0.3),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // Medium
                          color: Color(0xFFFEFEFF), // indpt/text primary
                          height: 21 / 14,
                        ),
                      ),
                      
                      const SizedBox(height: 2),
                      
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9C9C9D), // indpt/text tertiary
                          height: 18 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Radio button
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFFFFFBF1) // indpt/sand
                          : const Color(0xFF9C9C9D), // indpt/text tertiary
                      width: 2,
                    ),
                    color: isSelected 
                        ? const Color(0xFFFFFBF1) // indpt/sand
                        : Colors.transparent,
                  ),
                  child: isSelected 
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF242424), // indpt/accent
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    final canProceed = _amountController.text.isNotEmpty && 
                      int.tryParse(_amountController.text) != null && 
                      int.parse(_amountController.text) >= 10;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // indpt/neutral
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              color: canProceed && !isLoading
                  ? const Color(0xFFFFFBF1) // indpt/sand
                  : const Color(0xFF4D4E52), // indpt/stroke (disabled)
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: canProceed && !isLoading ? _proceedToConfirmation : null,
                borderRadius: BorderRadius.circular(44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF242424), // indpt/accent
                            ),
                          ),
                        )
                      : Text(
                          'Continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Medium
                            color: canProceed 
                                ? const Color(0xFF242424) // indpt/accent
                                : const Color(0xFF9C9C9D), // indpt/text tertiary
                            height: 24 / 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _proceedToConfirmation() {
    if (!mounted) return;
    
    final amount = _amountController.text;
    context.push('/wallet/add-money/confirm', extra: {
      'amount': amount,
      'paymentMethod': selectedPaymentMethod,
    });
  }
}