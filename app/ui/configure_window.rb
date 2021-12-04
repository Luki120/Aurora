require 'clipboard'

module Aurora

	class ConfigureWindow < Gtk::Window

		type_register

		class << self

			def init

				set_template resource: '/me/luki/aurora/ui/configure_window.ui'

				bind_template_child 'name_label'
				bind_template_child 'username_label'
				bind_template_child 'name_text_entry'
				bind_template_child 'username_text_entry'
				bind_template_child 'notes_label'
				bind_template_child 'notes_text_view'
				bind_template_child 'cancel_button'
				bind_template_child 'save_button'

			end

		end

		def initialize(application, password)

			super application: application

			set_title 'Configure Item'

			name_text_entry.text = password.name if password.name
			username_text_entry.text = password.username if password.username
			notes_text_view.buffer.text = password.notes if password.notes

			self.set_default_size 200, 200

			cancel_button.signal_connect 'clicked' do

				close

			end

			save_button.signal_connect 'clicked' do

				password.name = name_text_entry.text
				password.username = username_text_entry.text
				password.password = Clipboard.paste
				password.notes = notes_text_view.buffer.text

				password.save!
				close

				application_window = application.windows.find { |w| w.is_a? Aurora::VaultItemsWindow }
				application_window.load_vault_items

			end

		end

	end

end
