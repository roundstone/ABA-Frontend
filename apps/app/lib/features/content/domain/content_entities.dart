/// Domain entities representing content pages (About, Community, Partner Profiles).
class ContentPageSection {
  const ContentPageSection({
    required this.name,
    required this.title,
    required this.content,
    this.order = 0,
    this.status = 'Published',
  });

  final String name;
  final String title;
  final String content;
  final int order;
  final String status;
}

class ContentPage {
  const ContentPage({
    required this.slug,
    required this.title,
    required this.sections,
  });

  final String slug;
  final String title;
  final List<ContentPageSection> sections;
}

class CommunityFaqItem {
  const CommunityFaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class CommunityPartnerProfile {
  const CommunityPartnerProfile({
    required this.alias,
    required this.level,
    required this.downlineCount,
    required this.salesVolumeKobo,
    this.performancePercentile = 95,
    this.referralCode,
    this.bio,
    this.state = 'Abia',
  });

  final String alias;
  final int level;
  final int downlineCount;
  final int salesVolumeKobo;
  final int performancePercentile;
  final String? referralCode;
  final String? bio;
  final String state;

  double get salesVolumeNaira => salesVolumeKobo / 100.0;
}
