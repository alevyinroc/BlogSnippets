$StartURL = "http://firstresponderkit.org/"
invoke-webrequest $StartURL |select -expand content;