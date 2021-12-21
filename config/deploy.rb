# config valid for current version and patch releases of Capistrano
lock "~> 3.13.0"

set :application, "kevin-deploy"
set :scm, :git
set :repo_url, "ssh://git@github.com:22/carlosjarrieta/kevin_deploy.git"
set :branch, "master"
set :deploy_via, :copy
set :user, "deploy"
set :rvm_ruby_version, "2.6.5"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deploy/www/kevin"
set :linked_files, %w{config/database.yml config/master.key}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads node_modules}


before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, "deploy:restart"
  after :finishing, "deploy:cleanup"
end

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end
