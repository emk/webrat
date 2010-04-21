require "webrat/selenium/application_servers/base"

module Webrat
  module Selenium
    module ApplicationServers
      class RailsThin < Webrat::Selenium::ApplicationServers::Base

        def start
          system start_command
        end

        def stop
          silence_stream(STDOUT) do
            system stop_command
          end
        end

        def fail
          $stderr.puts
          $stderr.puts
          $stderr.puts "==> Failed to boot the Rails Thin application server... exiting!"
          $stderr.puts
          $stderr.puts "Verify you can start a Rails Thin server on port #{Webrat.configuration.application_port} with the following command:"
          $stderr.puts
          $stderr.puts "    #{start_command}"
          exit
        end

        def pid_file
          prepare_pid_file("#{RAILS_ROOT}/tmp/pids", "thin_selenium.pid")
        end

        def start_command
          if ActionController::Base.relative_url_root
            prefix = "--prefix #{ActionController::Base.relative_url_root}"
          else
            prefix = ""
          end
          "thin start -A rails -d #{prefix} --chdir #{RAILS_ROOT} --port #{Webrat.configuration.application_port} --environment #{Webrat.configuration.application_environment} --pid #{pid_file}"
        end

        def stop_command
          "thin stop --chdir #{RAILS_ROOT} --pid #{pid_file}"
        end

      end
    end
  end
end
