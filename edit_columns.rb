#!/usr/bin/env ruby

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

if __FILE__ == $0

$LOAD_PATH << '..'
load "../dudle.rb"

$d = Dudle.new

$d.table.edit_column($cgi["columnid"],$cgi["new_columnname"],$cgi) if $cgi.include?("new_columnname")
$d.table.delete_column($cgi["deletecolumn"]) if $cgi.include?("deletecolumn")

$d.wizzard_redirect

$d << "<h2>" + _("Add and Remove Columns") + "</h2>"
$d << $d.table.edit_column_htmlform($cgi["editcolumn"])

disabled, title, hidden = {},{},{}
hidden["common"] = ""
["add_remove_column_month","firsttime","lasttime"].each{|v|
	hidden["common"] += "<input type='hidden' name='#{v}' value='#{$cgi[v]}' />" if $cgi.include?(v)
}

$d.out
end
