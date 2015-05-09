module Lita
  module Handlers
    class Alias < Handler
      on :loaded, :load_stored_aliases

      route(/^alias\s+(\S+)\s+(.*)\s*$/, :alias, command: true, help: {
              'alias ALIAS COMMAND' => 'Creates ALIAS for COMMAND'
            }
           )

      route(/^unalias\s+(.+)/, :unalias, command: true, help: {
              'unalias ALIAS' => 'Remove ALIAS'
            }
           )

      def alias(response)
        aliasname = response.match_data[1]
        command = response.match_data[2]

        redis.set(aliasname, command)

        register_route(aliasname, command)

        response.reply "Alias '#{aliasname}' has been set to: #{command}"
      end

      # Register a route based on input
      # @todo Figure out why adding a new route doesn't replace the prior one
      # Need a `Set.new` somewhere?
      def register_route(aliasname, command)
        self.class.route(/^#{aliasname}$/, :echo, command: false, help: {
                           "#{aliasname}" => "alias to: #{command}"
                         }
                        )
      end

      def unalias(response)
        aliasname = response.match_data[1]

        case redis.del(aliasname)
        when 0
          response.reply "Alias '#{aliasname}' does not exist."
        else
          response.reply "Alias '#{aliasname}' has been removed."
        end
      end

      # @todo test coverage
      def load_stored_aliases(_payload)
        log.debug 'Loading stored aliases...'

        aliases = redis.keys

        log.debug "Found #{aliases.count} stored aliases."

        aliases.each do |aliasname|
          command = redis.get aliasname
          register_route(aliasname, command)
        end

        log.debug 'Completed alias registration.'
      end

      # @todo FIXME: remove debugging command, see {register_route}
      def echo(response)
        response.reply redis.get response.matches.first
      end
    end

    Lita.register_handler(Alias)
  end
end
