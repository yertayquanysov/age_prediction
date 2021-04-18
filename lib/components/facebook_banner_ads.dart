import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';

class FacebookBannerAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FacebookBannerAd(
      placementId: "223214319254272_223216222587415",
      bannerSize: BannerSize.LARGE,
    );
  }
}
