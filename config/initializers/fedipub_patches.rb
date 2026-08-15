# These patches live in files that aren't otherwise referenced, so Zeitwerk
# would only autoload (and apply) them when eager loading is on. Applying
# them inside `to_prepare` guarantees they're loaded on boot and on every
# code reload in development.
Rails.application.config.to_prepare do
  Fedipub::Server::ActorsController.prepend(Fedipub::Server::ActorsControllerPatch)
  Fedipub::Server::ActorPolicy.prepend(Fedipub::Server::ActorPolicyPatch)
end
