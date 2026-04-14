let
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiHIm57gTZIZe4UcdDpym9wSRiVkyfonz2FvRhWQ8eI root@thinkpad-e470";
  rpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJ/2lDwp/g4LL3L2NosVxYjDas1eqNsrVXEpoZ3EcrQ veke@thinkpad-e470";
  veke = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQZWl1cIfsXXKlTWenUlXqVG+txLKagrJatP+82OGin veke@thinkpad-e470";

  users = [ veke ];
  systems = [
    thinkpad
    rpi
  ];
in
{
  "wifi_rpi.age".publicKeys = users ++ [ rpi ];
  "wifi_thinkpad.age".publicKeys = users ++ [ thinkpad ];
  "kasa_hash.age".publicKeys = users ++ systems;
  "kasa_host.age".publicKeys = users ++ systems;
}
