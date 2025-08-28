import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: 'What is a domain name?',
      answer:
          'A domain name is your unique address on the internet. It\'s what users type in their browser to find your website. For example, "example.co.ke" is a domain name.',
    ),
    FAQItem(
      question: 'How do I register a .ke domain?',
      answer:
          'To register a .ke domain, you need to:\n1. Check domain availability\n2. Choose a registration period\n3. Provide required information\n4. Make payment\n5. Wait for confirmation',
    ),
    FAQItem(
      question: 'What are nameservers and why do I need them?',
      answer:
          'Nameservers are like an address book for your domain. They tell the internet where to find your website\'s content. When someone types your domain name, nameservers direct them to the correct server where your website is hosted.',
    ),
    FAQItem(
      question: 'How long does domain registration take?',
      answer:
          'Domain registration typically takes 24-48 hours to complete. However, the domain can be used immediately after payment confirmation in most cases.',
    ),
    FAQItem(
      question: 'What happens when my domain expires?',
      answer:
          'When your domain expires:\n1. Your website becomes inaccessible\n2. You have a grace period to renew\n3. After the grace period, the domain becomes available for others to register',
    ),
    FAQItem(
      question: 'Can I transfer my domain to another registrar?',
      answer:
          'Yes, you can transfer your domain to another registrar. You\'ll need:\n1. Authorization/EPP code from current registrar\n2. Domain unlocked status\n3. Valid email address\n4. Domain registered for at least 60 days',
    ),
    FAQItem(
      question: 'What is WHOIS privacy?',
      answer:
          'WHOIS privacy protects your personal information from being publicly visible in the WHOIS database. It replaces your contact details with proxy information while maintaining your ownership of the domain.',
    ),
    FAQItem(
      question: 'How do I point my domain to my website?',
      answer:
          'To point your domain to your website:\n1. Get nameservers from your hosting provider\n2. Update nameservers in your domain settings\n3. Wait for DNS propagation (24-48 hours)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'FAQs',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: AppPallete.kenicBlack,
        ),
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.chevronLeft, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQCard(faqs[index]);
        },
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Inter(
            text: faq.question,
            fontSize: 16,
            textAlignment: TextAlign.left,
            fontWeight: FontWeight.w600,
            textColor: AppPallete.kenicBlack,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPallete.kenicRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const HeroIcon(
              HeroIcons.questionMarkCircle,
              size: 20,
              color: AppPallete.kenicRed,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPallete.kenicRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const HeroIcon(
              HeroIcons.chevronDown,
              size: 20,
              color: AppPallete.kenicRed,
            ),
          ),
          children: [
            Text(
              faq.answer,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,

                color: AppPallete.greyColor,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
