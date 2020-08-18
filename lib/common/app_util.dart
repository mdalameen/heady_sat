class AppUtil {
  static String getCountString(int count, {bool allowNull: false}) {
    var subStrings = (int value, int digits) {
      if (digits == 0) digits = 3;
      if (value == null || (value < digits * 10)) return '';
      return value.toString().substring(0, digits);
    };

    var range = (int start, int end) {
      return (count.toString().length >= start &&
          count.toString().length <= end);
    };
    if (count == null) {
      if (allowNull)
        return null;
      else
        return '';
    }

    String sCount = count.toString();
    int cLength = sCount.length;
    if (cLength < 4) return sCount;
    String notation;

    if (range(0, 3))
      notation = '';
    else if (range(4, 6))
      notation = 'K';
    else if (range(7, 9))
      notation = 'M';
    else if (range(10, 12))
      notation = 'B';
    else if (range(13, 15))
      notation = 'T';
    else if (range(16, 18))
      notation = 'QT';
    else if (range(19, 21))
      notation = 'QI';
    else if (range(22, 24))
      notation = 'S';
    else if (range(25, 27))
      notation = 'SP';
    else
      notation = 'HI';
    return '' + subStrings(count, (cLength % 3)) + notation;
  }
}
