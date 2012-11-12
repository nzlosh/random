@debug = true

require 'securerandom' 
require 'sinatra'
require 'yaml'
require 'json'
require 'xmlsimple'
if ( @debug == true ) then
    require 'pp'
end


# Determine the character set to use.
def charset(type = nil)
    charset = ''

    puts "DEBUG: charset: type => #{type}" unless @debug == false

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

    puts "DEBUG: generator: charset => #{charset}, len => #{len}" unless @debug == false

    # Some sort of sanity checking. :P
    raise 'charset must be defined' unless ! charset == false

    # Unleash the fury !
    SecureRandom.random_bytes(len.to_i).unpack("C*").each { |a| result += charset[a%charset.length] }

    return result
end

# The result encodatron.
def encoder(enc = false, result = nil)
    puts "DEBUG: encoder: enc => #{enc}, result => #{result}" unless @debug == false

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

    puts "DEBUG: encoder: type => #{type}" unless @debug == false

    erb "result_#{type}".to_sym, :content_type => "text/#{type}", :locals => { :result => result }
end

# Routes go here.
def routes
	get '/' do
		erb :index
	end

    # The basic GET API, heh.
    get '/:enc/:charset/:len/:num' do
        pp params unless @debug == false

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


# Houston, we are go for runtime.
set :show_exceptions, false unless @debug == true
routes
