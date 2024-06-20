require 'clipboard'

module Aurora

	class ApplicationWindow < Gtk::ApplicationWindow

		attr_reader :invalid_entries

		# register the class in the Glib world
		type_register

		class << self

			def init

				# set the template from the resources binary
				set_template resource: '/me/luki/aurora/ui/glade/application_window.ui'

				bind_template_child 'random_string_label'
				bind_template_child 'generate_button'
				bind_template_child 'copy_button'
				bind_template_child 'vault_button'
				bind_template_child 'password_length_entry'

			end

		end

		def initialize(application)

			super application: application

			set_title 'Aurora'
			set_default_size 410, 250

			@invalid_entries = {
				:string_text_message => 'No text bozo, only integers',
				:empty_text_message => 'I can\'t do magic if you don\'t use your fucking keyboard',
				:out_of_range_message => 'Between 10 & 50 meatbag'
			}

			load_css
			password_length_entry.grab_focus_without_selecting
			random_string_label.text = generate_random_string_of_length 20
			setup_signals

		end

		def load_css

			css_file = File.expand_path('../../../resources/ui/css/styles.css', __FILE__)

			css_provider = Gtk::CssProvider.new
			css_provider.load(path: File.open(css_file).path)

			buttons = [
				generate_button,
				copy_button,
				vault_button
			]
			.each {
				|button| button.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
			}

		end

		def setup_signals

			generate_button.signal_connect 'clicked' do

				generate_password

			end

			copy_button.signal_connect 'clicked' do

				should_not_copy = random_string_label.text == @invalid_entries[:string_text_message] || random_string_label.text == @invalid_entries[:empty_text_message] || random_string_label.text == @invalid_entries[:out_of_range_message]
				Clipboard.copy random_string_label.text unless should_not_copy

			end

			vault_button.signal_connect 'clicked' do

				aurora_vault_items_window = Aurora::VaultItemsWindow.new(application, Aurora::Password.new(password_data_path: application.password_data_path))
				aurora_vault_items_window.present

			end

			password_length_entry.signal_connect 'changed' do

				generate_password 

			end

		end

		def generate_random_string_of_length(length)

			chars = Array('!'..'~')
			Array.new(length) { chars.sample }.join

		end

		def generate_password

		if !password_length_entry.text.is_i? && !password_length_entry.text.empty?
				random_string_label.text = @invalid_entries[:string_text_message]
			elsif password_length_entry.text.empty?
				random_string_label.text = @invalid_entries[:empty_text_message]
			elsif !password_length_entry.text.to_i.between?(10,50)
				random_string_label.text = @invalid_entries[:out_of_range_message]
			else
				random_string_label.text = generate_random_string_of_length(password_length_entry.text.to_i)
			end

		end

	end

end

# https://stackoverflow.com/a/1235990
class String

	def is_i?

	   /\A[-+]?\d+\z/ === self

	end

end
