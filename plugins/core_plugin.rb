class RandomGenerator
    attr_accessor :charset, :min, :mix, :count, :result

    def initialize(kwargs={})
        kwargs = { charset: "", min: 0, max: 8, count: 8}.merge(kwargs)
        @charset = kwargs[:charset]
        @min = kwargs[:min]
        @max = kwargs[:max]
        @count = kwargs[:count]
    end

    def random(kwargs={})
        kwargs = { min: @min, max: @max, count: @count}.merge(kwargs)
        @result = ""
        SecureRandom.random_bytes(@max).unpack("C*").each { |a| @result += @charset[a%charset.length] }
        return @result
    end

    def to_yaml()
        @result.to_yaml
    end

    def to_xml()
        XmlSimple.xml_out(@result, :RootName => 'raas_results')
    end

    def to_json()
        JSON.pretty_generate(@result)
    end

    def to_txt()
        return @result
    end

    def to_html()
    end

end

class NumberGenerator < RandomGenerator
    def random(kwargs={})
        kwargs = { min: @min, max: @max}.merge(kwargs)
        @min = kwargs[:min]
        @max = kwargs[:max]
        r = @max - @min
        @result = ""
        @result += (SecureRandom.random_number(r)+@min).to_s
        #~ @count.times do
            #~ r_num = SecureRandom.random_number(charset.length)
            #~ @result += @charset[r_num%charset.length]
        #~ end
        return @result
    end
end

class AsciiGenerator < RandomGenerator
    def initialize(kwargs={})
        kwargs = {charset: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'}.merge(kwargs)
        super(kwargs)
    end
end

class SafeAsciiGenerator < AsciiGenerator
    def initialize(kwargs={})
        kwargs = {charset: '23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ'}.merge(kwargs)
        super(charset)
    end
end

class WordGenerator < RandomGenerator
    attr_reader :fh

    def initialize(kwargs={})
        kwargs = {charset: [], dictfile: "/usr/share/dict/cracklib-smaller" }.merge(kwargs)
        if File.exists?(kwargs[:dictfile])
            @fh = File.new(kwargs[:dictfile], "r")
            @fh.each { |line| kwargs[:charset].push(line) }
            @fh.close
        else
            puts "Warning: Word Generator failed to load dictionary file from #{kwargs[:dictfile]}"
            kwargs[:charset] = [""]
        end
        super(kwargs)
    end


    def random(kwargs={})
        # max - maximum word length
        # min - minimum word length
        # count - number of words
        kwargs = { min: @min, max: @max, count: @count}.merge(kwargs)
        @result = ""
        @count.times do
            r_num = SecureRandom.random_number(charset.length)
            @result += @charset[r_num%charset.length]
        end
        return @result
    end

    def finished
        @fh.close if @fh.closed? == false
    end
end



class Test < Plugin::Plugin
    def initialize()
        @name = "myPluginTest"
    end

    def report
        super()
        puts "Extension plugin"
    end
end

# The plugin class MUST be registered with the
# Plugin Manager
plugin_manager.register(Test, true)


class NumberPlugin < Plugin::Plugin
    def initialize(kwargs={})
        super({ name: "number" })
    end
end

plugin_manager.register(NumberPlugin, true)

class WordPlugin < Plugin::Plugin
    def initialize(kwargs={})
        super({ name: "word" })
    end
end

plugin_manager.register(WordPlugin, true)
