module Aurora

	class VaultItemListBoxRow < Gtk::ListBoxRow

		type_register

		class << self

			def init

				set_template resource: '/me/luki/aurora/ui/vault_item_list_box_row.ui'

				bind_template_child 'vault_item_label'
				bind_template_child 'vault_item_button'
				bind_template_child 'delete_button'

			end

		end

		def initialize(item)

			super()

			vault_item_label.text = item.name || 'Unknown'

			vault_item_button.signal_connect 'clicked' do

				configure_window = ConfigureWindow.new(application, item)
				configure_window.present

			end

			delete_button.signal_connect 'clicked' do

				item.delete!

				application_window = application.windows.find { |w| w.is_a? Aurora::VaultItemsWindow }
				application_window.load_vault_items

			end

		end

		def application

			parent = self.parent
			parent = parent.parent while !parent.is_a? Gtk::Window
			parent.application

		end

	end

end
