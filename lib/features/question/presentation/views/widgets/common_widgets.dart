import 'package:flutter/material.dart';

// Custom TextField with focus detection
Widget buildTextField(TextEditingController controller, String hint,
    {int maxLines = 1, int minLines = 1, Function()? onTap}) {
  return TextField(
    controller: controller,
    decoration: inputDecoration(hint),
    maxLines: maxLines,
    minLines: minLines,
    onTap: onTap,
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF004aad), width: 2),
    ),
  );
}

Widget outlinedButton(String label, VoidCallback onPressed, {bool isLoading = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF004aad),
        side: const BorderSide(color: Color(0xFF004aad), width: 1.5),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF004aad),
        ),
      )
          : Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

Widget filledButton(String label, VoidCallback onPressed, {bool isLoading = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004aad),
        foregroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size(double.infinity, 48),
        disabledBackgroundColor: Colors.grey,
      ),
      child: isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

Widget aiResponseSection(String aiResponse) {
  if (aiResponse.isEmpty) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.green.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.smart_toy_outlined,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            const Text(
              "AI Response:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          aiResponse,
          style: TextStyle(color: Colors.green.shade800),
        ),
      ],
    ),
  );
}

// Improved Math Symbols Dropdown with clear English category names
class MathSymbolsDropdown extends StatefulWidget {
  final Function(String) onSymbolSelected;

  const MathSymbolsDropdown({
    Key? key,
    required this.onSymbolSelected,
  }) : super(key: key);

  @override
  _MathSymbolsDropdownState createState() => _MathSymbolsDropdownState();
}

class _MathSymbolsDropdownState extends State<MathSymbolsDropdown> {
  bool _isExpanded = false;
  int _selectedCategoryIndex = 0;

  final List<Map<String, List<String>>> _symbolCategories = [
    {
      'Basic Math': ['+', '-', '×', '÷', '=', '±', '≠', '≈', '∞', '%'],
    },
    {
      'Advanced Math': ['√', '∑', '∏', '^', '²', '³', 'π', 'e', '∫', '∂'],
    },
    {
      'Trigonometry': ['sin', 'cos', 'tan', 'csc', 'sec', 'cot', 'sin⁻¹', 'cos⁻¹', 'tan⁻¹'],
    },
    {
      'Hyperbolic': ['sinh', 'cosh', 'tanh', 'csch', 'sech', 'coth'],
    },
    {
      'Logarithms': ['log', 'ln', 'log₂', 'log₁₀', 'lg'],
    },
    {
      'Relations': ['<', '>', '≤', '≥', '∈', '∉', '⊂', '⊆', '∪', '∩'],
    },
    {
      'Greek Letters': ['α', 'β', 'γ', 'δ', 'θ', 'λ', 'μ', 'σ', 'φ', 'ω'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF004aad).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004aad),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.functions,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Insert Math Symbols",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004aad),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004aad).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF004aad),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1, color: Colors.grey),

            // Category tabs
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _symbolCategories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final categoryName = entry.value.keys.first;
                    final isSelected = _selectedCategoryIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF004aad) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF004aad) : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF004aad).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF004aad),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Symbols grid
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symbolCategories[_selectedCategoryIndex]
                    .values
                    .first
                    .map((symbol) => _buildSymbolButton(symbol))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymbolButton(String symbol) {
    return InkWell(
      onTap: () {
        widget.onSymbolSelected(symbol);
      },
      child: Container(
        width: 45,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          symbol,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF004aad),
          ),
        ),
      ),
    );
  }
}