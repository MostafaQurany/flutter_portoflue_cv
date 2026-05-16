class RoutePaths {
  const RoutePaths._();

  static const String home = '/';
  static const String projectDetails = '/project/:id';
  static const String adminLogin = '/admin/login';
  static const String adminAddProject = '/admin/add-project';

  static String projectDetailsById(String id) => '/project/$id';
}
