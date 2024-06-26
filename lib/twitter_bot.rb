require 'twitter'
require 'dotenv'
Dotenv.load
#definir la classe twetter qui encapsule les fonctionnalités du bot twitter
class TwitterBot 
    #Definit un accesseur en lecture pour l'attribut @client
    ettr_reader :client 

    def initialize
        #creer une nouvelle instance de twetter::REST::Client avec les clés d'Api Twitter
        @client = Twitter::REST:Client.new do |config|
            config.consumer_key = ENV["CONSUMER_KEY"]
            config.consumer_secret = ENV["CONSUMER_SECRET"]
            config.access_token = ENV["ACCESS_TOKEN"]
            config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
        end
    end

    def say_hello
        #definit une liste de journaliste a contacter
        journalists = []
        #selectionner 5 journalistes au hazard
        sample = journalists.sample(5)
        sample.each do |journalists|
            #pour chaque journaliste selectionne envoie un message personnaliser et le hashtage #hello world
            tweet("Hello #{journalists}, thanks you for your work! #hello world @TS_4Afreeka")
            #attend 15 seconde pour eviter d'etre bannie par twitter
            sleep(15)
        end
    end


    def like_hello_worlds_tweets
        #recherche les 25 derniers tweet avec le hashtage #hello_world
        Twitter::REST::Client.new(client.configuration).search("#hello_world", result_type: "resent", count: 100).each do |tweet|
            #aime chaque tweet trouver
            client.favorite(tweet.id)
            sleep(15)
        end
    end

    def follow_hello_world_users
        #recherche les 20 derniers utilisateur ayant tweeter sur le hashtage #hello_world
        Twitter::REST::Client.new(client.configuration).search("#hello_world", result_type: "resent", count: 100).each do |tweet|
            #suit chaque utilisteur trouver
            client.follow(tweet.user.id)
            sleep(15)
        end
    end

    def live_reaction
        #creer un nouveau client de streaming twitter
        stream = Twitter::Streaming::Client.new(client.configuration) do |object|
            #si l'objet reçu est un tweet contenant le hashtage #hello_world
            if object.is_a?(Twitter::Tweet) && object.text.include?("#hello_world")
                #affiche le text du tweet dans la console
                puts "New tweet: #{object.text}"
                client.favorite(object.id)
                client.follow(object.user.id)
            end
        end
        #demarre le streaming en suivant le hashtag #hello_world
        stream.filter(track: "#hello_world")
    end

    private

    def tweet(message)
        client.update(message)
    end
end
