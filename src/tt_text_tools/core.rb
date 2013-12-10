#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'

#-------------------------------------------------------------------------------


module TT::Plugins::TextTools


  ### MENU & TOOLBARS ### ------------------------------------------------------

  unless file_loaded?( __FILE__ )
    # Menus
    m = UI.menu( 'Plugins' )
    m.add_item( 'Search and Replace Text…' ) { self.search_and_replace }
  end


  ### MAIN SCRIPT ### ----------------------------------------------------------

  def self.search_and_replace
    prompts = ['Search: ', 'Replace: ']
    input = UI.inputbox( prompts, [], 'Search and Replace Text' )

    return unless input

    from, to = input

    model = Sketchup.active_model
    self.start_operation('Search and Replace')

    model.entities.grep(Sketchup::Text) { |text|
      self.replace(text, from, to)
    }
    model.definitions.each { |d|
      next if d.image?
      d.entities.grep(Sketchup::Text) { |text|
        self.replace(text, from, to)
      }
    }

    model.commit_operation
  end

  def self.replace(text_entity, from, to)
    text_entity.text = text_entity.text.gsub(from, to)
  end

  ### HELPER METHODS ### ---------------------------------------------------

  def self.start_operation(name)
    model = Sketchup.active_model
    # Make use of the SU7 speed boost with start_operation while
    # making sure it works in SU6.
    if Sketchup.version.split('.')[0].to_i >= 7
      model.start_operation(name, true)
    else
      model.start_operation(name)
    end
  end

end # module

#-------------------------------------------------------------------------------

file_loaded( __FILE__ )

#-------------------------------------------------------------------------------
