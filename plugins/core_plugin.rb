class RandomGenerator < Plugin::Plugin
    attr_accessor :charset, :min, :mix, :count, :result

    def initialize(kwargs={})
        kwargs = { charset: "", min: 0, max: 8, count: 8}.merge(kwargs)
        @charset = kwargs[:charset]
        @min = kwargs[:min]
        @max = kwargs[:max]
        @count = kwargs[:count]
        super(kwargs)
    end

    def randomise(kwargs={})
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
    def initialize(kwargs={})
        kwargs = { name: "Digits"}.merge(kwargs)
        super(kwargs)
    end

    def randomise(kwargs={})
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
        kwargs = {name: "Ascii", charset: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'}.merge(kwargs)
        super(kwargs)
    end
end

class SafeAsciiGenerator < RandomGenerator
    def initialize(kwargs={})
        kwargs = {name: "SafeAscii", charset: '23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ'}.merge(kwargs)
        super(kwargs)
    end
end

class WordGenerator < RandomGenerator
    attr_reader :fh

    def initialize(kwargs={})
        kwargs = {name: "CrackLib", charset: [], dictfile: "/usr/share/dict/cracklib-smaller" }.merge(kwargs)
        if File.exists?(kwargs[:dictfile])
            @fh = File.new(kwargs[:dictfile], "r")
            @fh.each { |line| kwargs[:charset].push(line) }
            @fh.close
        else
            $log.warn("Word Generator failed to load dictionary file from #{kwargs[:dictfile]}")
            kwargs[:charset] = [""]
        end
        super(kwargs)
    end

    def randomise(kwargs={})
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


# Plugin classes MUST be registered with the Plugin Manager to be
# used in the application.  It's done here.
@plugin_manager.register(NumberGenerator, true)
@plugin_manager.register(AsciiGenerator, true)
@plugin_manager.register(SafeAsciiGenerator, true)
@plugin_manager.register(WordGenerator, true)


