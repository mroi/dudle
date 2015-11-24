# encoding: utf-8
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

require "yaml"
require "cgi"

$cgi = CGI.new unless $cgi

$LOAD_PATH << '.'
require 'gettext'
require 'gettext/cgi'
include GetText
GetText.cgi=$cgi
GetText.output_charset = 'utf-8'
require "locale"

if File.exists?("data.yaml") && !File.stat("data.yaml").directory?
	$is_poll = true
	GetText.bindtextdomain("dudle", :path => Dir.pwd + "/../locale/")
else
	$is_poll = false
	GetText.bindtextdomain("dudle", :path => Dir.pwd + "/locale/")
end

$:.push("..")
require "date_locale"

require "html"
require "poll"
require "config_defaults"
require "charset"

class Dudle
	attr_reader :html, :table, :urlsuffix, :title, :tab
	def is_poll?
		$is_poll
	end
	def tabs_to_html(active_tab)
		ret = "<div id='tabs'><ul id='tablist'>"
		@tabs.each{|tab,file|
			case file
			when _(active_tab)
				ret += "<li id='active_tab' class='active_tab' >&nbsp;#{tab}&nbsp;</li> "
			when ""
				ret += "<li class='separator_tab'></li>"
			else
				ret += "<li class='nonactive_tab' ><a href='#{@html.relative_dir}#{file}'>&nbsp;#{tab}&nbsp;</a></li> "
			end
		}
		ret += "</ul></div>"
		ret
	end

	def inittabs
		@tabs = []
		@tabs << [_("Home"),@basedir]
		if is_poll?
			@tabs << ["",""]
			@tabs << [_("Poll"),"."]
			@tabs << ["",""]
			@configtabs = [
				[_("Edit Columns"),"edit_columns.cgi"],
				[_("Invite Participants"),"invite_participants.cgi"],
				[_("Overview"),"overview.cgi"]
			]
			@tabs += @configtabs
			@tabs << [_("Delete Poll"),"delete_poll.cgi"]
			@tabs << ["",""]
		end
		@tabtitle = @tabs.collect{|title,file| title if file == @tab}.compact[0]
	end

	def initialize(params = {:title => nil, :relative_dir => ""})
		@cgi = $cgi
		@tab = File.basename($0)
		@tab = "." if @tab == "index.cgi"

		if is_poll?
			@basedir = ".." 
			inittabs
			datafile = File.open("data.yaml", File::RDWR)
			datafile.flock(File::LOCK_EX)
			@table = YAML::load(datafile.read)
			@urlsuffix = File.basename(File.expand_path("."))
			@title = @table.name
			
			
			configfiles = @configtabs.collect{|name,file| file}
			@is_config = configfiles.include?(@tab)
			@wizzardindex = configfiles.index(@tab) if @is_config

			@html = HTML.new("dudle - #{@title} - #{@tabtitle}",params[:relative_dir])
			@html.header["Cache-Control"] = "no-cache"
		else
			@basedir = "."
			inittabs
			@title = params[:title] || "dudle"
			@html = HTML.new(@title,params[:relative_dir])
		end


		
		@css = ["default", "classic", "print"].collect{|f| f + ".css"}
		@css.each{|href|
			@html.add_css("#{@basedir}/#{href}",href.scan(/([^\/]*)\.css/).flatten[0], href == "default.css")
		}

		@html << <<HEAD
<body><div id="top"></div>
<div id='main'>
#{tabs_to_html(@tab)}
<div id='content'>
	<h1 id='polltitle'>#{@title}</h1>
HEAD
	end

	def wizzard_nav
		ret = "<div id='wizzard_navigation'><table><tr>"
		[[_("Previous"),@wizzardindex == 0],
		 [_("Next"),@wizzardindex >= @configtabs.size()-2],
		 [_("Finish"),@wizzardindex == @configtabs.size()-1]].each{|button,disabled|
			ret += <<READY
				<td>
					<form method='post' action=''>
						<div>
							<input type='submit' #{disabled ? "disabled='disabled'" : ""} name='#{button}' value='#{button}' />
						</div>
					</form>
				</td>
READY
		}
		ret += "</tr></table></div>"
	end

	def wizzard_redirect
		[[_("Previous"),@wizzardindex-1],
		 [_("Next"),@wizzardindex+1],
		 [_("Finish"),@configtabs.size()-1]].each{|action,linkindex|
			if $cgi.include?(action)
				@html.header["status"] = "REDIRECT"
				@html.header["Cache-Control"] = "no-cache"
				@html.header["Location"] = @configtabs[linkindex][1]
				@html << _("All changes were saved sucessfully.") + " <a href=\"#{@configtabs[linkindex][1]}\">" + _("Proceed!") + "</a>"
				out
				exit
			end
		}
	end

	def out
		@html << wizzard_nav if @is_config

		@html.add_cookie("lang",@cgi["lang"],"/",Time.now + (1*60*60*24*365)) if @cgi.include?("lang")
		@html << "</div>" # content
		@html << "</div>" # main
		$conf.footer.each{|f| @html << f }

		@html << "</body>"
		@html.out(@cgi)
	end

	def <<(htmlbodytext)
		@html << htmlbodytext
	end

end
