# Credits ⇝ https://iridakos.com/programming/2018/01/25/creating-a-gtk-todo-application-with-ruby

module Aurora

	class Application < Gtk::Application

		attr_reader :password_data_path

		def initialize

			super "me.luki.aurora", Gio::ApplicationFlags::FLAGS_NONE

			@password_data_path = File.expand_path('~/RubyStuff/Aurora/Vault/')

			unless File.directory?(@password_data_path)

				puts "First launch, creating password data path at: #{@password_data_path}"
				FileUtils.mkdir_p(@password_data_path)

			end

			signal_connect "activate" do |application|

				window = Aurora::ApplicationWindow.new(application)
				window.present

			end

		end

	end

end
