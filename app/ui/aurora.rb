module Aurora

=begin
	
	seems like it's common to write Ruby using
	2 spaces indentation, well fuck that, that's ugly
	I always used 4 tab size so that'll have to suffice
	I already have enough with the snake case smh
	
=end

	class Application < Gtk::Application

		attr_reader :password_data_path

		def initialize

			super "me.luki.aurora", Gio::ApplicationFlags::FLAGS_NONE

			@password_data_path = File.expand_path('~/RubyFancyStuff/Apps/Aurora/Vault/')

			unless File.directory?(@password_data_path)

				puts "First launch, creating password data path: #{@password_data_path}"
				FileUtils.mkdir_p(@password_data_path)

			end

			signal_connect "activate" do |application|

				window = Aurora::ApplicationWindow.new(application)
				window.present

			end

		end

	end

end
