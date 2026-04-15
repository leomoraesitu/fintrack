/// Define os breakpoints de responsividade do app FinTrack.
/// Use em conjunto com [MediaQuery] e widgets responsivos.
class AppBreakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}
