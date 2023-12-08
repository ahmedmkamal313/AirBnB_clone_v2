# Script that sets up web static

# Install nginx package
package { 'nginx':
  ensure => present,
}

# Create /data/web_static/releases/test/ directory
file { '/data/web_static/releases/test/':
  ensure => directory,
  mode   => '0755',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Create /data/web_static/shared/ directory
file { '/data/web_static/shared/':
  ensure => directory,
  mode   => '0755',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Create /data/web_static/current symbolic link
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
  force  => true,
}

# Create /data/web_static/current/index.html file
file { '/data/web_static/current/index.html':
  ensure  => file,
  mode    => '0644',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
}

# Update /etc/nginx/sites-available/default file
file_line { 'web_static':
  path  => '/etc/nginx/sites-available/default',
  line  => 'location /hbnb_static/ { alias /data/web_static/current/; }',
  match => '^server {',
  after => '^server {',
}

# Restart nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
  notify  => Exec['reload_nginx'],
}

# Reload nginx configuration
exec { 'reload_nginx':
  command     => 'service nginx reload',
  refreshonly => true,
}
