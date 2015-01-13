 # config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'Appointr'
set :repo_url, 'git@github.com:vinsol/Appointr.git'

set :deploy_to, '/var/www/Appointr'
set :scm, :git
set :branch, 'web-pay'
set :format, :pretty
set :sudo, false
set :scm_command, '/usr/bin/git'
set :log_level, :debug
set :linked_files, %w{config/database.yml
                      config/secrets.yml}

set :linked_dirs, %w{log
                    tmp
                    vendor/bundle
                    public}

set :keep_releases, 15

namespace :deploy do
  after :publishing, :restart

  after :restart, :unicorn_restart do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          Rake::Task[:'unicorn:hard_restart'].invoke
        end
      end
    end
  end
end

namespace :unicorn do
  task :hard_restart do
    Rake::Task[:'unicorn:stop'].invoke
    Rake::Task[:'unicorn:start'].invoke
  end

  desc 'start unicorn'
  task :start do
    on roles(:app), in: :parallel do
      within current_path do
        execute :bundle, :exec, "unicorn_rails -c config/unicorn.rb -D -E #{ fetch(:rails_env) }"
      end
    end
  end

  desc 'stop unicorn'
  task :stop do
    on roles(:app), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid`"
        end
      end
    end
  end

  desc 'restart unicorn'
  task :restart do
    on roles(:app), in: :parallel do
      within current_path do
        execute "kill -s USR2 `cat #{shared_path}/tmp/pids/unicorn.pid`"
      end
    end
  end
end

namespace :database do
  desc 'create database'
  task :create do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'migration'
  task :migrate do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:migrate'
        end
      end
    end
  end

  desc 'seed'
  task :seed do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
end
