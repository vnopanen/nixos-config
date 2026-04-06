let
  veke_thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiHIm57gTZIZe4UcdDpym9wSRiVkyfonz2FvRhWQ8eI root@thinkpad-e470";
  veke_rpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJ/2lDwp/g4LL3L2NosVxYjDas1eqNsrVXEpoZ3EcrQ veke@thinkpad-e470";
  
  users = [ veke_thinkpad ];
  systems = [ veke_rpi ];
in
{
  "wifi_rpi.age".publicKeys = users ++ [ veke_rpi ];
  "wifi_thinkpad.age".publicKeys = users ++ [ veke_thinkpad ];
  "kasa_hash.age".publicKeys = users ++ [ veke_thinkpad ];
}
