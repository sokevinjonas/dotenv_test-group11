require 'twitter_bot'

describe twitterbot do
    let(:bot) {TwitterBot.new}

    describe "initialize" do
        it "logs in to Twitter" do
            expect(bot.client).to be_a(Twitter::REST::Client)
        end
    end
end
