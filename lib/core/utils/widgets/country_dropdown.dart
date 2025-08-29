import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class CountryDropdown extends StatelessWidget {
  final String? selectedCountry;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CountryDropdown({
    super.key,
    this.selectedCountry,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          countryListTheme: CountryListThemeData(
            flagSize: 25,
            backgroundColor: AppPallete.kenicWhite,
            textStyle: TextStyle(color: AppPallete.kenicBlack, fontSize: 14),
            bottomSheetHeight: 500,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            inputDecoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Start typing to search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppPallete.greyColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          onSelect: (Country country) {
            onChanged(country.countryCode);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppPallete.greyColor.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child:
                  selectedCountry != null
                      ? Row(
                        children: [
                          Text(
                            _getFlagEmoji(selectedCountry!),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Inter(
                              text: selectedCountry!,
                              fontSize: 14,
                              textColor: AppPallete.kenicBlack,
                            ),
                          ),
                        ],
                      )
                      : Inter(
                        text: 'Select Country',
                        fontSize: 14,
                        textColor: AppPallete.greyColor,
                      ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppPallete.greyColor),
          ],
        ),
      ),
    );
  }

  String _getFlagEmoji(String countryCode) {
    // Simple flag emoji mapping for common countries
    const Map<String, String> flagEmojis = {
      'KE': '🇰🇪', // Kenya
      'UG': '🇺🇬', // Uganda
      'TZ': '🇹🇿', // Tanzania
      'RW': '🇷🇼', // Rwanda
      'BI': '🇧🇮', // Burundi
      'SS': '🇸🇸', // South Sudan
      'ET': '🇪🇹', // Ethiopia
      'SO': '🇸🇴', // Somalia
      'DJ': '🇩🇯', // Djibouti
      'ER': '🇪🇷', // Eritrea
      'ZA': '🇿🇦', // South Africa
      'NG': '🇳🇬', // Nigeria
      'EG': '🇪🇬', // Egypt
      'GH': '🇬🇭', // Ghana
      'US': '🇺🇸', // United States
      'GB': '🇬🇧', // United Kingdom
      'CA': '🇨🇦', // Canada
      'AU': '🇦🇺', // Australia
      'DE': '🇩🇪', // Germany
      'FR': '🇫🇷', // France
      'IT': '🇮🇹', // Italy
      'ES': '🇪🇸', // Spain
      'NL': '🇳🇱', // Netherlands
      'BE': '🇧🇪', // Belgium
      'CH': '🇨🇭', // Switzerland
      'AT': '🇦🇹', // Austria
      'SE': '🇸🇪', // Sweden
      'NO': '🇳🇴', // Norway
      'DK': '🇩🇰', // Denmark
      'FI': '🇫🇮', // Finland
      'JP': '🇯🇵', // Japan
      'CN': '🇨🇳', // China
      'IN': '🇮🇳', // India
      'BR': '🇧🇷', // Brazil
      'MX': '🇲🇽', // Mexico
    };

    return flagEmojis[countryCode] ?? '🏳️';
  }
}
