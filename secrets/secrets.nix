let
  user1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC79jOYrfyd4hKxdSYmDxXskOzFXuIfKoBU+eUB4tbwbQnf72Iwr4+sNv8V01NM5ehbnnvkmQ5dT3w1hZIkQRlz4DgG0wvNZP7iTT1uNQyGwqsQUviv1RlM7GToYZiEl5JpC0OePnsPHngc0AgkX+zodt1IeW8pJhFNMgmeB38nsQEXwcgVbVIjdQxbcvD1x5XPk+kIcPJo7+x49AXAuyrviuzpe6USYN1lkXfb387yNHdVX5zwcYf21ElUfhOfuUh0WC6V1hIG9HCJASwtXzEW56kvhRRArUo3Of8DfehMKzL9Km6XKcxh/kxyIbMYj3pwq4f32nL41/UrU8tHl/RA+FCJ1ksmd3IKL97sKOJsyLHGzi9pyy6KxH4Q+Xo17w9ygZg9Eq1p0nZRFg9wawJzntMb/IJNgRwQWrekpGRDp17FeMgRF6kFviXkbjNwVWpA1wk3k3a/l2CRICqa6z5Zvh7yLG43SigjVCk3gvvwEih3v3ig1ViGDC42gXRc2sc=";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6VNZbOWvDFKQJNkSqZN20Q57WkmpM/3kXYwf5IWGpk thomaslaich@lenovo-desktop";
in
{
  "gcal-clientid.age".publicKeys = [
    user1
    user2
  ];
  "gcal-clientsecret.age".publicKeys = [
    user1
    user2
  ];
  "authinfo.age".publicKeys = [
    user1
    user2
  ];
  "netrc.age".publicKeys = [
    user1
    user2
  ];
  "claptrap.age".publicKeys = [
    user1
    user2
  ];
}
