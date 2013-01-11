require 'securerandom'
require 'sinatra'
require 'yaml'
require 'json'
require 'xmlsimple'

require 'logger'
$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG

require 'pp' if $log.level == Logger::DEBUG

# Application module
require './plugin_framework'

# Load configuration file
s = ""
File.open("./raas.conf", "r").each { |l| s += l }
$config = YAML::load(s)


# Determine the character set to use.
def charset(type = nil)
    charset = ''

    $log.debug("charset: type => #{type}")

    charset = case type
        when 'ab' then '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        when 'as' then '23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ'
        when 'hex' then '0123456789abcdef'
        when 'num' then '0123456789'
        else raise 'invalid charset'
    end

    return charset
end

# Generate the string.
def generator(charset = false, len = 16)
    result = ''

    $log.debug("generator: charset => #{charset}, len => #{len}")

    # Some sort of sanity checking. :P
    raise 'charset must be defined' unless ! charset == false

    # Unleash the fury !
    SecureRandom.random_bytes(len.to_i).unpack("C*").each { |a| result += charset[a%charset.length] }

    return result
end

# The result encodatron.
def encoder(enc = false, result = nil)
    $log.debug("encoder: enc => #{enc}, result => #{result}")

    # Some sort of sanity checking. :P
    raise 'encoding must be defined' unless ! enc == false
    raise 'result must be an array' unless result.is_a?(Array)

    type = nil
    type = case enc
        when 'p' then 'plain'
        when 'y' then 'yaml'
        when 'j' then 'json'
        when 'h' then 'html'
        when 'x' then 'xml'
        else raise 'encoding is something strange and terrifying'
    end

    $log.debug("encoder: type => #{type}")

    erb "result_#{type}".to_sym, :content_type => "text/#{type}", :locals => { :result => result }
end

# Routes go here.
def routes(plugin_manager)
    get '/' do
        erb :index
    end

    get '/:plugin/:presentation/:min/:max/:count' do
        @r = nil
        @p = "to_"
        requested_plugin = params[:plugin]
        $log.debug(pp params)
        if plugin_manager.has_plugin(requested_plugin)
            plugin = plugin_manager.plugin_instance(requested_plugin,{count:88})
            plugin.randomise
            $log.debug(pp plugin)
            @p = "#{@p}#{params[:presentation]}"
            $log.debug(@p)
            if plugin.methods.member?(:"#{@p}")
                @r = plugin.send("#{@p}")
            else
                @r = "Unsupported data presentation."
            end
        else
            @r = "Available plugins <br> "
            plugin_manager.list_plugins.each { |p| @r += "#{p}<br>" }
        end
        @r
    end

    # The basic GET API, heh.
    get '/:enc/:charset/:len/:num' do
        $log.debug(pp params)

        # Determine the character set to use.
        set = charset(params[:charset])

        # Build an array full of random.
        result = []
        params[:num].to_i.times do
            result.push(generator(set, params[:len]))
        end

        # Give the array back the way the user wants it.
        encoder(params[:enc], result)
    end

    get '*' do
        erb :dunno
    end
end


# Initialise the plugin framework.
plugin_manager = Plugin::Register.new
load_plugin(plugin_manager)

$log.debug( "Available plugins:" )
plugin_manager.list_plugins.each { |p| $log.debug(p) }

# Houston, we are go for runtime.
set :show_exceptions, false unless $log.level == Logger::DEBUG
routes(plugin_manager)
