import 'package:get/get.dart';

class PrivacyController extends GetxController {
  final List<SectionData> sections = [
    SectionData(
      title: 'Privacy Policy',
      paragraphs: [
        'This privacy statement represents the privacy policy applicable to all legal entities owned by Renergy Power Sdn Bhd. In the event of any changes to this privacy statement for the betterment of our services, we will post such changes here. Please read and understand this privacy statement before providing your information to us or using our services.',
        'This privacy statement applies to https://www.renergypowergroup.com and the websites of any Renergy Power Sdn Bhd\'s legal entity and related online activities. Further, this privacy statement provides information to external data subjects who are not engaged or employed by Renergy Power Sdn Bhd, where the data subjects provide us with Personal Data, or we collect data as part of our normal business operations, from a third-party service provider, contract partner, public sources, previous employers or organisations, trade fairs or communications channels such as email.'
      ],
    ),
    SectionData(
      title: 'How and Why We Use Personal Data',
      paragraphs: ['We process Personal Data to operate, improve, and provide our services and support, consistent with law and our legitimate interests.'],
    ),
    SectionData(
      title: 'Personal Data',
      bullets: [
        'Name (including individual or business entity registered name)',
        'Personal identification details (including passport details)',
        'Email address',
        'Phone number',
        'Address, State, Postal Code, City',
        'Banking details',
        'Preferred language',
        'Preferred services or products',
        'Other relevant information'
      ],
    ),
    SectionData(
      title: 'When you visit our website',
      paragraphs: [
        'We collect data through cookies to track the activity on our website. The data collected through cookies consists of data relating to your device, IP address and your usage of the websites. We use the data collected through cookies to provide you with the best user experience and for improving the websites\' content by tracking usage patterns and recording preferences and for allowing you to log on to specific sites.'
      ],
    ),
    SectionData(
      title: 'When you subscribe to a newsletter or contact us',
      paragraphs: [
        'When you contact us, such as for business relations or interest, ordering products and services or in relation to projects, media or investor contacts, supplier relations, sponsorships, or sign up for an event, we collect your Personal Data in order to enable us to meet your request or interest, provide support, or comply with contractual obligations or prepare to enter into a contract. When we have an existing customer relationship with you, we may also use your Personal Data to provide communication and direct market our products and services.'
      ],
    ),
    SectionData(
      title: 'Integrity due diligence investigations',
      paragraphs: [
        'If and when we deem necessary, we will evaluate integrity due diligence investigations. This includes collection information to evaluate potential business relations or partners, their operation and business ethics. This investigation may include processing of Personal Data such as organisations position and roles, connections or relations to public authorities\' representatives or relevant decision makers, possible sanction listings, contracts, relevant memberships, references, legal claims and reputational issues. The legal basis is to comply with legal obligations, pursue our legitimate interests and to establish, exercise or defend legal claims.'
      ],
    ),
    SectionData(
      title: 'Sharing of Personal Data',
      paragraphs: [
        'We will not share your Personal Data with third parties except in circumstances where such sharing is necessary as part of our regular business operations or to provide our services and support to you.',
        'Occasionally we use external third-party service providers for delivering services on our behalf and on our instructions as set out in a data processing agreement with the relevant service provider. We use such service providers for consultancy purposes, recruitment services, financial services, security services, IT services, communication services and integrity due diligence services. In such instances, we may share your Personal Data with such parties to the extent necessary to perform such work.',
        'We will not knowingly disclose your Personal Data to third parties for the purposes of allowing them to market their products or services to you.',
        'When required by law, regulation, legal process or an enforceable governmental request, we may share your Personal Data for legal reasons within Renergy Power Sdn Bhd and to public authorities or governments but only to the extent we are required to do so.'
      ],
    ),
    SectionData(
      title: 'Transfer of Personal Data',
      paragraphs: [
        'Your personal information may be transferred to and maintained on computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.',
        'Your consent to the Privacy Statement followed by your submission of such information represents your agreement to that transfer.',
        'We will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Statement and no transfer of your personal information will take place to an organisation or a country unless there are adequate controls in place including the security of your data and other personal information.'
      ],
    ),
    SectionData(
      title: 'Cookies',
      paragraphs: [
        'Some of our website or Service may use cookies and similar tracking technologies to track the activity on our website or service and hold certain information.',
        'Cookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device.',
        'In the event you do not wish to receive such cookies, you may configure your browser to refuse all cookies or to indicate when a cookie is being sent. However, you may not be able to use all the features and functionality of our website or service.'
      ],
    ),
    SectionData(
      title: 'Security of Processing',
      paragraphs: [
        'We will process your Personal Data securely and will apply and maintain appropriate technical and organisations measures to protect your Personal Data against accidental or unlawful destruction or accidental loss, alteration, unauthorised disclosure or access, in particular where the processing involves the transmission of data over a network, and against all other unlawful forms of processing.',
        'Access to Personal Data is strictly limited to authorised personnel of Renergy Power Sdn Bhd and affiliates who have appropriate authorisation and a clear business need for that data.'
      ],
    ),
    SectionData(
      title: 'Retention and Deletion of Data',
      paragraphs: [
        'Your Personal Data will be retained as long as necessary to fulfil the legitimate purpose(s) for the processing and as long as required by law. If you or your employer have a contractual relationship with us, any Personal Data relating to you will be retained as long as necessary to enable us to fulfil our obligations relating to that contractual relationship.',
        'If you consent to certain processing, we store your Personal Data until you withdraw your consent or once the Personal Data is no longer necessary for achieving the purpose of the processing.'
      ],
    ),
    SectionData(
      title: 'Privacy Statements of Third Parties',
      paragraphs: [
        'This Privacy Statement addresses the collection, use and disclosure of Personal Data by Renergy Power Sdn Bhd as described above. This Privacy Statement does not address or govern the privacy practices adopted by third parties on third party websites or in relation to third party services that may be accessible through use of the website. Although we try only to link to websites that share our high standards for privacy, we are not in any way responsible for the content or the privacy practices employed by third party websites or third-party services. We encourage you to familiarise yourself with the privacy policies applicable to such websites or services prior to providing them with your Personal Data.'
      ],
    ),
    SectionData(
      title: 'Changes to This Privacy Statement',
      paragraphs: [
        'We may update our Privacy Statement from time to time. If such updates are minor and do not have a material meaning for your rights or the way we use Personal Data, we may make such changes without posting a specific notice on our website. You are advised to review this Privacy Statement periodically for any changes.'
      ],
    ),
    SectionData(
      title: 'Contact Us',
      paragraphs: [
        'Renergy Power Group',
        'Email: info@renergypowergroup.com',
        'Phone: +6012-643-3168',
        'Website: http://renergypowergroup.com',
      ],
    ),
  ];
}

class SectionData {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
  SectionData({required this.title, this.paragraphs = const [], this.bullets = const []});
}