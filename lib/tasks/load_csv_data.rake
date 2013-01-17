require 'csv'
require 'geokit'

namespace :db do
	desc "Populate our tables"
	task :populate => :environment do
		
		#remove old data - DO NOT RUN THIS ON EXSISTING DATABASE!
		#Event.delete_all
		#Funder.delete_all
		#Location.delete_all
		#Page.delete_all
		#Project.delete_all
		#ActiveRecord::Base.connection.execute(
		#	"delete from tags; delete from taggings;")

		#read in data, skip first two lines since they includes headings
		count = 0
		CSV.read(File.join(RAILS_ROOT, 'db/programming_inventory.csv'))[2..-1].each do |fields|
			e = Event.new
      
      #project event is associated with
      project = Project.find_or_create_by_name(fields[0].to_s.strip)

			#event name
			e.name = fields[1].to_s.strip
			
			#page the event is associated with
			page = Page.find_or_create_by_name(fields[2].to_s.strip)

			#lab contact for the event
			e.lab_contact = fields[3].to_s.strip #comma space delimited

			#partner contact for the event
			e.partner_contact = fields[4].to_s.strip #comma space delimited
			
			#orgs
			unless fields[5].to_s.blank?
			 organizations = fields[5].to_s.split(', ')
			 organizations.each {|organization| e.organization_list << organization.strip}
			end
			
			#impact loc
			unless fields[6].to_s.blank?
			 locations = fields[6].to_s.split('; ')
			 locations.each {|location| e.location_list << location.strip}
			end
			
			#org collaboration (now just orgs)
			unless fields[7].to_s.blank?
			 organizations = fields[7].to_s.split(', ')
			 organizations.each {|organization| e.organization_list << organization.strip}
			end

			#start/end date
			e.start_date    = (fields[8].to_s.blank? ? nil : Date.parse(fields[8].to_s.strip))
			e.end_date      = (fields[9].to_s.blank? ? nil : Date.parse(fields[9].to_s.strip))

			#funders
			unless fields[10].to_s.blank?
				funders = fields[10].to_s.split(', ')
				funders.each do |funder|
					page_funder = Funder.find_or_create_by_fullname(funder.strip)
					page.funders << page_funder unless page.funders.include?(page_funder)
				end
			end
			
			#age counts
			e.pre_school						= fields[11].to_i
			e.elementary_school			= fields[12].to_i
			e.middle_school					= fields[13].to_i
			e.high_school						= fields[14].to_i
			e.adult									= fields[15].to_i
			
			#skip column 16 since it contains age count totals and we do not store this
			
			#student dialogue
			unless fields[17].to_s.blank?
			 connection_dialogues = fields[17].to_s.split(', ')
			 connection_dialogues.each {|connection_dialogue| e.connection_dialog_list << connection_dialogue.strip}
			end

			#affiliations
			unless fields[18].to_s.blank?
			 affiliations = fields[18].to_s.split(', ')
			 affiliations.each {|affiliation| e.affiliation_list << affiliation.strip}
			end

			#geo scope
		  e.geographic_scope_list << fields[19].to_s.strip unless fields[19].to_s.blank?

			#comments
			e.comments = fields[20].to_s.strip

			#arenas
			unless fields[21].to_s.blank?
			 	arenas = fields[21].to_s.split(', ')
			 	arenas.each {|arena| e.arena_list << arena.strip}
			end
			
			#web links...
			unless fields[22].to_s.blank?
			 	web_links = fields[22].to_s.split(', ')
			 	web_links.each {|web_link| e.web_link_list << web_link.strip}
			end
			
			#tags
			unless fields[23].to_s.blank?
			 	tags = fields[23].to_s.split(', ')
			 	tags.each {|tag| e.tag_list << tag.strip}
			end

			#does the project have outreach
			project.has_outreach = fields[24] == "TRUE" || fields[24].blank?
			
			#what is the status of this project
			project.status = fields[25].to_s.strip

			#link the admin to this event
			e.users << User.find_by_login("admin")
			
			#save project
			project.is_published = true
			project.save!
			page.project = project
			
			#save page
			page.is_published = true
			page.save!
			
			#save event
			e.page = page
			e.is_published = true
			e.save!
			
			count += 1
			puts "Event #{count} processed"
		
			#locations
			e.location.each do |loc|
				location = Location.find_by_name(loc.name)
				next if location
				location = Location.new
				location.name = e.location.first.name
				res = Geokit::Geocoders::MultiGeocoder.geocode("#{location.name}")
				location.lat = res.lat
				location.lng = res.lng
				location.save!
			end
		end

		#link the admin to all the projects created
		projects = Project.all
		user = User.find_by_login("admin")
		user.projects << projects
		user.save!
		
	end
end