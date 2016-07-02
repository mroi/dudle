# coding: utf-8
############################################################################
# Copyright 2009,2010 Benjamin Kellermann                                  #
#                                                                          #
# This file is part of dudle.                                              #
#                                                                          #
# Dudle is free software: you can redistribute it and/or modify it under   #
# the terms of the GNU Affero General Public License as published by       #
# the Free Software Foundation, either version 3 of the License, or        #
# (at your option) any later version.                                      #
#                                                                          #
# Dudle is distributed in the hope that it will be useful, but WITHOUT ANY #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public     #
# License for more details.                                                #
#                                                                          #
# You should have received a copy of the GNU Affero General Public License #
# along with dudle.  If not, see <http://www.gnu.org/licenses/>.           #
############################################################################

require "ostruct"
$conf = OpenStruct.new

$conf.footer = []
$conf.footer << <<FOOTER
<p id="footer">Der <a target="_blank" href="https://github.com/mroi/nextcloud-dudle">Quellcode dieser Anwendung ist verfügbar</a> unter der <a target="_blank" href="http://www.gnu.org/licenses/agpl-3.0.html">Lizenz AGPLv3</a>.</p>
FOOTER

$conf.indexnotice = <<INDEXNOTICE
<h2>Aktuelle Umfragen</h2>
<table>
	<tr>
		<th>Umfrage</th><th>Letzte Änderung</th>
	</tr>
INDEXNOTICE
Dir.glob("*/data.yaml").sort_by{|f|
	File.new(f).mtime
}.reverse.collect{|f| f.gsub(/\/data\.yaml$/,'') }.each{|site|
	$conf.indexnotice += <<INDEXNOTICE
<tr class='participantrow'>
	<td class='polls'><a href='./#{CGI.escapeHTML(site).gsub("'","%27")}/'>#{CGI.escapeHTML(site)}</a></td>
	<td class='mtime'>#{File.new(site + "/data.yaml").mtime.strftime('%d.%m., %H:%M')}</td>
</tr>
INDEXNOTICE
}
$conf.indexnotice += "</table>"

if File.exists?("config.rb") || File.exists?("../config.rb")
	require_relative "config"
end
