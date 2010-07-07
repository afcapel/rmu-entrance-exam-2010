module TextEditor
  class Document
    def initialize
      @commands = []
      @reverted = []
    end
    
    def contents
      @cached_contents ||= build_contents 
    end

    def add_text(text, position=-1)
      execute { @contents.insert(position, text) }
    end

    def remove_text(first=0, last=contents.length)
      execute { @contents.slice!(first...last) }
    end

    def execute(&block)
      @cached_contents = nil
      @commands << block
      @reverted = []
    end

    def undo
      return if @commands.empty?
      @cached_contents = nil
      @reverted << @commands.pop
    end

    def redo
      return if @reverted.empty?
      @cached_contents = nil
      @commands << @reverted.pop
    end
    
    private
    
    def build_contents
       @contents = ""
       @commands.each {|command| command.call}
       @contents
    end
  end
end
