# frozen_string_literal: true

class Discussion::Actions::Profile::Save < Discussion::Action
  include Discussion::Deps[
    repo: "repositories.profile",
    create: "commands.create_profile"
  ]

  require_signed_in_user!

  params do
    optional(:username).filled(:str?)
    optional(:avatar)
  end

  def handle(req, res)
    profile = repo.from_current_user(res[:current_user])
    if profile
      params = req.params.to_h
      params.delete(:username)
      repo.update(profile.id, params)
    else
      create.call(nickname: req.params[:username], avatar: req.params[:avatar], 
        account_id: res[:current_user].id)
    end
    res.redirect "/profile"
  end
end