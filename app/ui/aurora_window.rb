require 'clipboard'

module Aurora

	class ApplicationWindow < Gtk::ApplicationWindow

		# register the class in the Glib world

		type_register

		class << self

			def init

				# set the template from the resources binary

				set_template resource: '/me/luki/aurora/ui/application_window.ui'

				bind_template_child 'random_string_label'
				bind_template_child 'generate_button'
				bind_template_child 'copy_button'
				bind_template_child 'vault_button'
				bind_template_child 'password_length_entry'

			end

		end		  

		def initialize(application)

			super application: application

			set_title "Aurora"

			self.set_default_size 350, 250

			def generate_password_string(number)

				charset = Array('A'..'Z') + Array('a'..'z') + Array['!', '@', '#', '$', '%', '&', '*', '(', ')', '_', '+', '-', '=', '[', ']', '{', '}', '|', ';', '\'', ':', '"', ',', '.', '/', '<', '>', '?', '\\']
				Array.new(number) { charset.sample }.join

			end

			generate_button.signal_connect 'clicked' do

				random_string_label.text = generate_password_string(password_length_entry.text.to_i)

			end

			copy_button.signal_connect 'clicked' do

				Clipboard.copy random_string_label.text

			end

			vault_button.signal_connect 'clicked' do

				aurora_vault_item_window = Aurora::VaultItemsWindow.new(application, Aurora::Password.new(password_data_path: application.password_data_path))
				aurora_vault_item_window.present

			end

		end

	end

end
