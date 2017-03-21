Dudle Polls for Nextcloud
=========================

[Dudle](https://github.com/kellerben/dudle/) is a self-hosted online poll system developed 
by Benjamin Kellermann and many other contributers. This fork integrates Dudle as an app 
into [Nextcloud](https://Nextcloud.org). I also stripped it down considerably to reduce the 
required dependencies and simplify running it on shared hosting platforms. Many features 
such as version control and customization are gone.

You install the Dudle app within Nextcloud by cloning this repository into a new directory 
`apps/dudle` within your Nextcloud installation. Make sure to rename the folder resulting 
from the clone from `nextcloud-dudle` to just `dudle`. You can then enable the Dudle app in 
the Nextcloud app selection dialog.

Note that currently, access control is not available. Everyone accessing the Nextcloud app 
has full permissions to create and delete polls.

This work is licensed under the [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html) or 
higher.
