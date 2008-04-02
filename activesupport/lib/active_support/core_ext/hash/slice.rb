require 'set'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Slice a hash to include only the given keys. This is useful for
      # limiting an options hash to valid keys before passing to a method:
      #
      #   def search(criteria = {})
      #     assert_valid_keys(:mass, :velocity, :time)
      #   end
      #
      #   search(options.slice(:mass, :velocity, :time))
      #
      # Also allows leaving out certain keys. This is useful when duplicating
      # a hash but omitting a certain subset:
      #
      #   Event.new(event.attributes.without(:id, :user_id))
      module Slice
        # Returns a new hash with only the given keys.
        def slice(*keys)
          allowed = Set.new(respond_to?(:convert_key) ? keys.map { |key| convert_key(key) } : keys)
          reject { |key,| !allowed.include?(key) }
        end

        # Replaces the hash with only the given keys.
        def slice!(*keys)
          replace(slice(*keys))
        end

        # Returns a new hash without the given keys.
        def without(*keys)
          allowed = self.keys - (respond_to?(:convert_key) ? keys.map { |key| convert_key(key) } : keys)
          slice(*allowed)
        end

        # Replaces the hash without the given keys.
        def without!(*keys)
          replace(without(*keys))
        end
      end
    end
  end
end
