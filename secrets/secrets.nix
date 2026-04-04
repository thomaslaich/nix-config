let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPlbIYCBPhwffWb/AbrAqTXyhl7+QqLXc6NZA5mjqm4 thomaslaich@gmail.com";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6VNZbOWvDFKQJNkSqZN20Q57WkmpM/3kXYwf5IWGpk";
in
{
  # "gcal-clientid.age".publicKeys = [
  #   user1
  #   user2
  # ];
  # "gcal-clientsecret.age".publicKeys = [
  #   user1
  #   user2
  # ];
  # "authinfo.age".publicKeys = [
  #   user1
  #   user2
  # ];
  # "netrc.age".publicKeys = [
  #   user1
  #   user2
  # ];
  "claptrap.age".publicKeys = [
    user1
    user2
  ];
}
