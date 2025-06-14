// دالة حساب العمر بالسنوات
int calculateAge(DateTime birthDate) {
  final now = DateTime.now();
  int age = now.year - birthDate.year;

  // تحقق من إذا كان عيد الميلاد لم يأت بعد هذا العام
  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }

  return age;
}

// دالة حساب العمر المفصل (سنوات، شهور، أيام)
Map<String, int> calculateDetailedAge(DateTime birthDate) {
  final now = DateTime.now();

  int years = now.year - birthDate.year;
  int months = now.month - birthDate.month;
  int days = now.day - birthDate.day;

  // تعديل الحسابات إذا كانت الأيام سالبة
  if (days < 0) {
    months--;
    // الحصول على عدد أيام الشهر السابق
    final previousMonth = DateTime(now.year, now.month, 0);
    days += previousMonth.day;
  }

  // تعديل الحسابات إذا كانت الشهور سالبة
  if (months < 0) {
    years--;
    months += 12;
  }

  return {'years': years, 'months': months, 'days': days};
}

// دالة تحويل العمر إلى نص قابل للقراءة
String formatAge(DateTime birthDate) {
  final ageDetails = calculateDetailedAge(birthDate);
  final years = ageDetails['years']!;
  final months = ageDetails['months']!;
  final days = ageDetails['days']!;

  if (years > 0) {
    if (months > 0) {
      return '$years years, $months months old';
    } else {
      return '$years years old';
    }
  } else if (months > 0) {
    if (days > 0) {
      return '$months months, $days days old';
    } else {
      return '$months months old';
    }
  } else {
    return '$days days old';
  }
}

// دالة حساب العمر بالأيام
int calculateAgeInDays(DateTime birthDate) {
  final now = DateTime.now();
  return now.difference(birthDate).inDays;
}

// دالة التحقق من صحة تاريخ الميلاد
bool isValidBirthDate(DateTime birthDate) {
  final now = DateTime.now();
  final minDate = DateTime(1900, 1, 1);

  return birthDate.isAfter(minDate) && birthDate.isBefore(now);
}

// دالة تحويل العمر إلى تاريخ ميلاد تقريبي
DateTime ageToApproximateBirthDate(int age) {
  final now = DateTime.now();
  return DateTime(now.year - age, now.month, now.day);
}
