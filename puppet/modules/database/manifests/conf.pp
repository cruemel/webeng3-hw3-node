define conf(
  $config = "/etc/couchdb/local.ini",
  $bind_address = "127.0.0.1"
)

{
  file_line { "couchdb-bind_address-${bind_address}":
    path => $config,
    match => ";?bind_address",
    line => "bind_address = $bind_address"
  }
}
