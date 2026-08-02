class GroupDecorator < Draper::Decorator
  delegate_all

  def to_s
    name
  end

  def path
    if object.fedipub_actor.local?
      "#"
    else
      object.fedipub_actor.federated_url
    end
  end
end
