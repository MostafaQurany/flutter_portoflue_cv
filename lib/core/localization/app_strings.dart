import 'app_locale.dart';

class AppStrings {
  final AppLocale locale;
  const AppStrings(this.locale);

  static AppStrings of(AppLocale locale) => AppStrings(locale);

  // Navigation
  String get home => locale.isRtl ? 'الرئيسية' : 'Home';
  String get about => locale.isRtl ? 'عنّي' : 'About';
  String get projects => locale.isRtl ? 'المشاريع' : 'Projects';
  String get contact => locale.isRtl ? 'تواصل' : 'Contact';
  String get adminAccess => locale.isRtl ? 'دخول المدير' : 'Admin access';

  // Hero Section
  String get gotProject => locale.isRtl ? 'لديك مشروع؟' : 'Got a project?';
  String get myResume => locale.isRtl ? 'سيرتي الذاتية' : 'My resume';

  // Projects Section
  String get selectedProjects => locale.isRtl ? 'مشاريع مختارة' : 'Selected projects';
  String get projectsSubtitle => locale.isRtl 
    ? 'كل مشروع يسحب من البيانات المثرية، بما في ذلك الشعارات وروابط المنصات والأوصاف الطويلة.'
    : 'Each entry now pulls from the enriched project dataset, including logos, platform links, and descriptions.';
  String get viewDetails => locale.isRtl ? 'عرض التفاصيل' : 'View details';
  String get moreTechnologies => locale.isRtl ? 'تقنيات أخرى' : 'more technologies';
  String get moreInDetails => locale.isRtl ? 'المزيد في صفحة التفاصيل.' : 'More in details page.';
  String get errorLoadingProjects => locale.isRtl ? 'تعذّر تحميل بيانات المشاريع.' : 'Unable to load projects data.';

  // Project Details
  String get projectNotFound => locale.isRtl ? 'المشروع غير موجود.' : 'Project not found.';
  String get errorLoadingDetails => locale.isRtl ? 'تعذّر تحميل تفاصيل المشروع.' : 'Unable to load project details.';
  String get projectType => locale.isRtl ? 'نوع المشروع' : 'Project type';
  String get technologyCount => locale.isRtl ? 'عدد التقنيات' : 'Technology count';
  String get mediaItems => locale.isRtl ? 'الوسائط' : 'Media items';
  String get tools => locale.isRtl ? 'أدوات' : 'tools';
  String get screenshots => locale.isRtl ? 'لقطات شاشة' : 'screenshots';
  String get projectLinks => locale.isRtl ? 'روابط المشروع' : 'Project links';
  String get appPreview => locale.isRtl ? 'معاينة التطبيق' : 'App Preview';
  String get unableToOpenLink => locale.isRtl ? 'تعذّر فتح الرابط.' : 'Unable to open project link.';

  // Admin
  String get adminLogin => locale.isRtl ? 'تسجيل دخول المدير' : 'Admin login';
  String get adminSubtitle => locale.isRtl 
    ? 'هذه منطقة محصورة مجهزة للتكامل المستقبلي مع لوحة التحكم.'
    : 'This is a guarded entry point prepared for future backend integration.';
  String get username => locale.isRtl ? 'اسم المستخدم' : 'Username';
  String get password => locale.isRtl ? 'كلمة المرور' : 'Password';
  String get enterAdminArea => locale.isRtl ? 'الدخول لمنطقة الإدارة' : 'Enter admin area';
  String get addProject => locale.isRtl ? 'إضافة مشروع' : 'Add project';
  String get submitProject => locale.isRtl ? 'إرسال المشروع' : 'Submit project';
  String get signOut => locale.isRtl ? 'تسجيل الخروج' : 'Sign out';
  String get enterUsername => locale.isRtl ? 'أدخل اسم المستخدم' : 'Enter your username';
  String get enterPassword => locale.isRtl ? 'أدخل 4 أحرف على الأقل' : 'Enter at least 4 characters';
  String get projectTitle => locale.isRtl ? 'عنوان المشروع' : 'Project title';
  String get projectDescription => locale.isRtl ? 'وصف المشروع' : 'Description';
  String get repositoryUrl => locale.isRtl ? 'رابط المستودع' : 'Repository URL';
  String get enterTitle => locale.isRtl ? 'أدخل عنواناً' : 'Enter a title';
  String get enterDescription => locale.isRtl ? 'أدخل 20 حرفاً على الأقل' : 'Enter at least 20 characters';
  String get enterValidUrl => locale.isRtl ? 'أدخل رابطاً صالحاً' : 'Enter a valid URL';
  String get formValidated => locale.isRtl 
    ? 'تم التحقق من صحة النموذج. التخزين مؤجل للمرحلة المستقبلية.' 
    : 'Project form validated. Persistence is deferred to a future backend phase.';
  String get adminFormSubtitle => locale.isRtl
    ? 'نموذج إدارة للواجهة الأمامية فقط مع التحقق وحماية المسار.'
    : 'Frontend-only admin form with validation and route protection in place.';
  String get thumbnailDeferred => locale.isRtl
    ? 'تحميل الصورة المصغرة مؤجل حتى وجود عقود التخزين وواجهة البرمجيات.'
    : 'Thumbnail upload is intentionally deferred until storage and API contracts exist.';

  // Common
  String get loading => locale.isRtl ? 'جاري التحميل...' : 'Loading...';
  String get error => locale.isRtl ? 'حدث خطأ' : 'An error occurred';
}
