module Remarkable
  module AASM
    module Matchers
      class AASM < Remarkable::ActiveRecord::Base
        arguments :name

        assertion :aasm?, :aasm_column?, :aasm_initial_state?, :aasm_states?, :aasm_events?

        optionals :initial_state
        optionals :states
        optionals :events

        protected

          def aasm?
            subject_class.respond_to?(:aasm_states)
          end

          def aasm_column?
            subject_class.aasm_column == @name.to_sym
          end

          def aasm_initial_state?
            return true unless @options.key?(:initial_state)
            subject_class.aasm_initial_state == @options[:initial_state]
          end

          def aasm_states?
            return true unless @options.key?(:states)

            Array(@options[:states]).to_a.each do |state|
              return false unless subject_class.aasm_states.include?(state)
            end

            true
          end

          def aasm_events?
            return true unless @options.key?(:events)

            Array(@options[:events]).each do |event|
              return false unless subject_class.aasm_events.keys.include?(event)
            end

            true
          end
      end

      def aasm(*args, &block)
        AASM.new(*args, &block).spec(self)
      end
    end
  end
end

