# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

json = ActiveSupport::JSON.decode(File.read('db/seeds/json/JmaWeatherCode.json'))
json.each{|key, value|
    JmaWeatherCode.create(
        weather_code:    key,
        day_image:       value[0],
        night_image:     value[1],
        about_code:      value[2],
        weather:         value[3],
        weatehr_english: value[4]
    )
}