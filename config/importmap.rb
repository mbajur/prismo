# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/timeago", to: "@stimulus-components--timeago.js" # @5.0.2
pin "date-fns", to: "https://ga.jspm.io/npm:date-fns@4.1.0/index.js"
pin "@floating-ui/dom", to: "@floating-ui--dom.js" # @1.8.0
pin "@floating-ui/core", to: "@floating-ui--core.js" # @1.8.0
pin "@floating-ui/utils", to: "@floating-ui--utils.js" # @0.2.12
pin "@floating-ui/utils/dom", to: "@floating-ui--utils--dom.js" # @0.2.12
pin "@yaireo/tagify", to: "@yaireo--tagify.js" # @4.38.0
pin "debounce" # @3.0.0
pin "@rails/request.js", to: "@rails--request.js.js"
pin "@avo-hq/marksmith", to: "@avo-hq--marksmith.js" # @0.5.1
