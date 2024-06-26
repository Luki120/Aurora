module Aurora

	class VaultItemsWindow < Gtk::Window

		type_register

		class << self

			def init

				set_template resource: '/me/luki/aurora/ui/glade/vault_items_window.ui'

				bind_template_child 'add_vault_items_button'
				bind_template_child 'vault_items_list_box'

			end

		end

		def initialize(application, password)

			super application: application

			set_title 'Vault Items'

			self.set_default_size 350, 250

			add_vault_items_button.signal_connect 'clicked' do

				aurora_configure_window = ConfigureWindow.new(application, Aurora::Password.new(password_data_path: application.password_data_path))
				aurora_configure_window.present

			end

			load_css
			load_vault_items

		end

		def load_css

			css_file = File.expand_path('../../../resources/ui/css/styles.css', __FILE__)

			css_provider = Gtk::CssProvider.new
			css_provider.load(path: File.open(css_file).path)

			add_vault_items_button.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

		end

		def load_vault_items

			vault_items_list_box.children.each { |child| vault_items_list_box.remove child }

			json_files = Dir[File.join(File.expand_path(application.password_data_path), '*.json')]
			items = json_files.map { |filename| Aurora::Password.new(filename: filename) }

			items.each do |password|

				vault_items_list_box.add Aurora::VaultItemListBoxRow.new(password)

			end

		end

	end

end
