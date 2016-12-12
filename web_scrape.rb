require 'json'

require 'json'
require 'net/http'
require 'httparty'
require 'pry'
require 'awesome_print'

# Change this to the title of the season you want
SEASON_TOURNAMENT_CONST = "na_2016_summer"

json_response = HTTParty.get("http://api.lolesports.com/api/v1/scheduleItems?leagueId=2").parsed_response

tournaments = json_response["highlanderTournaments"]

SEASON_TOURNAMENT_CONST = nil
tournaments.each do |t|
    SEASON_TOURNAMENT_CONST = t if t["title"] == "na_2016_summer"
end

tournament_id = SEASON_TOURNAMENT_CONST["id"]

brackets = SEASON_TOURNAMENT_CONST["brackets"]

regular_season = nil
brackets.each do |k, v|
    regular_season = v if v["name"] == "regular_season"
end

matches = regular_season["matches"]

matches.each do |key, match|
    match_id = match["id"]
    
    match_details_json = HTTParty.get("http://api.lolesports.com/api/v2/highlanderMatchDetails?tournamentId=#{tournament_id}&matchId=#{match_id}").parsed_response

    match_details_json["gameIdMappings"].each do |game|
        long_id = game["id"]
        game_hash = game["gameHash"]
        
        game = match["games"][long_id]
        
        game_id = game["gameId"]
        game_realm = game["gameRealm"]
        
        puts "https://acs.leagueoflegends.com/v1/stats/game/#{game_realm}/#{game_id}?gameHash=#{game_hash}"
    end
end