// all routes require authenticated state by default.
// here we store the exceptions
final List<String> allowAnonymousRoutes = [
  '/login',
  '/register',
  '/resetPassword',
  '/reset-password',
];
