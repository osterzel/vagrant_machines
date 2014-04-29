include baseconfig

class { 'apache': mpm_module => 'prefork' }
class { 'apache::mod::php': }

class { '::mysql::server':
  root_password    => 'dev',
  override_options => { 'mysqld' => { 'bind_address' => '0.0.0.0', 'max_connections' => '1024' } }
}

mysql_user { 'root@%':
    password_hash   => mysql_password('dev')
}

mysql_grant { 'root@%/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'root@%',
}

class { 'phpmyadmin': }
