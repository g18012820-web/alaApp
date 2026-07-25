abstract class DurationProvider {
  const DurationProvider._();

  static const veryLong = 700;
  static const long = 500;
  static const medium = 300;
  static const short = 150;
  static const extraShort = 80;
  static const oneSecond = 1000;
}

final class OneSecondDuration extends Duration {
  const OneSecondDuration() : super(milliseconds: DurationProvider.oneSecond);
}

final class VeryLongDuration extends Duration {
  const VeryLongDuration() : super(milliseconds: DurationProvider.veryLong);
}

final class LongDuration extends Duration {
  const LongDuration() : super(milliseconds: DurationProvider.long);
}

final class MediumDuration extends Duration {
  const MediumDuration() : super(milliseconds: DurationProvider.medium);
}

class ShortDuration extends Duration {
  const ShortDuration() : super(milliseconds: DurationProvider.short);
}

final class ExtraShortDuration extends Duration {
  const ExtraShortDuration() : super(milliseconds: DurationProvider.extraShort);
}
