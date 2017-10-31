part of grizzly.math;

/// Computes the inverse of Normal distribution function
///
/// Returns the argument, x, for which the area under the
/// Gaussian probability density function (integrated from
/// minus infinity to x) is equal to y.
///
/// For small arguments 0 < y < exp(-2), the program computes
/// z = sqrt( -2.0 * log(y) );
/// then the approximation is
/// x = z - log(z)/z  - (1/z) P(1/z) / Q(1/z).
///
/// There are two rational functions P/Q, one for 0 < y < exp(-32)
/// and the other for y up to exp(-2).  For larger arguments,
/// w = y - 0.5, and  x/sqrt(2pi) = w + w**3 R(w**2)/S(w**2)).
double normalInv(double y0) {
  /* sqrt(2pi) */
  const double s2pi = 2.50662827463100050242E0;

/* approximation for 0 <= |y - 0.5| <= 3/8 */
  const List<double> _p0 = const <double>[
    -5.99633501014107895267E1,
    9.80010754185999661536E1,
    -5.66762857469070293439E1,
    1.39312609387279679503E1,
    -1.23916583867381258016E0,
  ];

  const List<double> _q0 = const <double>[
/* 1.00000000000000000000E0, */
    1.95448858338141759834E0,
    4.67627912898881538453E0,
    8.63602421390890590575E1,
    -2.25462687854119370527E2,
    2.00260212380060660359E2,
    -8.20372256168333339912E1,
    1.59056225126211695515E1,
    -1.18331621121330003142E0,
  ];

/* Approximation for interval z = sqrt(-2 log y ) between 2 and 8
 * i.e., y between exp(-2) = .135 and exp(-32) = 1.27e-14.
 */
  const List<double> _p1 = const <double>[
    4.05544892305962419923E0,
    3.15251094599893866154E1,
    5.71628192246421288162E1,
    4.40805073893200834700E1,
    1.46849561928858024014E1,
    2.18663306850790267539E0,
    -1.40256079171354495875E-1,
    -3.50424626827848203418E-2,
    -8.57456785154685413611E-4,
  ];

  const List<double> _q1 = const <double>[
/*  1.00000000000000000000E0, */
    1.57799883256466749731E1,
    4.53907635128879210584E1,
    4.13172038254672030440E1,
    1.50425385692907503408E1,
    2.50464946208309415979E0,
    -1.42182922854787788574E-1,
    -3.80806407691578277194E-2,
    -9.33259480895457427372E-4,
  ];

/* Approximation for interval z = sqrt(-2 log y ) between 8 and 64
 * i.e., y between exp(-32) = 1.27e-14 and exp(-2048) = 3.67e-890.
 */

  const List<double> _p2 = const <double>[
    3.23774891776946035970E0,
    6.91522889068984211695E0,
    3.93881025292474443415E0,
    1.33303460815807542389E0,
    2.01485389549179081538E-1,
    1.23716634817820021358E-2,
    3.01581553508235416007E-4,
    2.65806974686737550832E-6,
    6.23974539184983293730E-9,
  ];

  const List<double> _q2 = const <double>[
/*  1.00000000000000000000E0, */
    6.02427039364742014255E0,
    3.67983563856160859403E0,
    1.37702099489081330271E0,
    2.16236993594496635890E-1,
    1.34204006088543189037E-2,
    3.28014464682127739104E-4,
    2.89247864745380683936E-6,
    6.79019408009981274425E-9,
  ];

  if (y0 <= 0.0) {
    return double.NEGATIVE_INFINITY;
  }
  if (y0 >= 1.0) {
    return double.INFINITY;
  }

  int code = 1;
  double y = y0;
  if (y > (1.0 - 0.13533528323661269189)) {
    /* 0.135... = exp(-2) */
    y = 1.0 - y;
    code = 0;
  }

  double x = 0.0;

  if (y > 0.13533528323661269189) {
    y = y - 0.5;
    final double y2 = y * y;
    x = y + y * (y2 * polyval(y2, _p0) / _p1evl(y2, _q0));
    x = x * s2pi;
    return (x);
  }

  x = math.sqrt(-2.0 * math.log(y));
  final double x0 = x - math.log(x) / x;
  double x1 = 0.0;
  final double z = 1.0 / x;
  if (x < 8.0) /* y > exp(-32) = 1.2664165549e-14 */
    x1 = z * polyval(z, _p1) / _p1evl(z, _q1);
  else
    x1 = z * polyval(z, _p2) / _p1evl(z, _q2);
  x = x0 - x1;
  if (code != 0) x = -x;
  return (x);
}
