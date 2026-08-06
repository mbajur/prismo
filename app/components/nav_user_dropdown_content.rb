module Components
  class NavUserDropdownContent < Base
    def view_template(&)
      DropdownMenuContent do
        DropdownMenuLabel { current_user.decorate.to_s }
        DropdownMenuSeparator
        DropdownMenuItem(href: current_user.decorate.path) { "Profile" }
        DropdownMenuItem(href: destroy_user_session_path, data: { turbo_method: :delete }) { "Sign-out" }
      end
    end
  end
end
