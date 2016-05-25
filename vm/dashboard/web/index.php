<?php

require_once __DIR__.'/../vendor/autoload.php';

$app = new Silex\Application();

// Load configuration
$yaml = new \Symfony\Component\Yaml\Parser();
$config = $yaml->parse(file_get_contents('/vagrant-config/config.default.yml'));
if (file_exists('/vagrant-config/config.yml')) {
  $local_config = $yaml->parse(file_get_contents('/vagrant-config/config.yml'));
  $config['config'] = array_merge($config['config'], $local_config['config']);
}
$app['config'] = $config['config'];

// Load Dev Tools
$app['home_url'] = 'http://' . $_SERVER['HTTP_HOST'];
$app['home_url_without_port'] = 'http://' . $_SERVER['SERVER_NAME'];
$app['tools'] = [
  [
    'name' => 'Database Administration', 
    'description' => 'Login with username: root, password: ' . $app['config']['mysql']['password'],
    'url' => $app['home_url'] . '/phpmyadmin',
  ],

  [
    'name' => 'Webserver Logs',
    'url' => $app['home_url'] . '/logs',
  ],
  [
    'name' => 'Email Capture',
    'url' => $app['home_url_without_port'] . ':' . $app['config']['mailhog']['port'],
  ],
  [
    'name' => 'PHP Information',
    'url' => $app['home_url'] . '/dashboard/phpinfo',
  ]
];

// Load list of user sites.
$sites = [];

if (!empty($app['config']['sites']['single_app'])) {
  $sites[] = [
    'path' => '/',
    'name' => !empty($app['config']['sites']['app_name']) ? $app['config']['sites']['app_name'] : 'PHP Application',
  ];
}
else {
  if (!empty($app['config']['sites']['dir']) && file_exists($app['config']['sites']['dir'])) {
    $sites = array_filter(glob($app['config']['sites']['dir'] . '/*'), 'is_dir');
  }
  foreach ($sites as $i => $site) {
    $sites[$i] = [
      'path' => '/' . basename($site),
      'name' => basename($site),
    ];
  }
}
$app['sites'] = $sites;


// Register services
$app->register(new Silex\Provider\TwigServiceProvider(), array(
  'twig.path' => __DIR__.'/../views',
));

// Add Routes
$app->get('/', function () use ($app) {
  return $app['twig']->render('home.twig', [
    'sites' => $app['sites'],
    'tools' => $app['tools'],
  ]);
});

$app->get('/phpinfo', function () use ($app) {
  return phpinfo();
});

$app->run();
