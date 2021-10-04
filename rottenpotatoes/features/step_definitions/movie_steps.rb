# Add a declarative step here for populating the DB with movies.

Given /the following movies exist:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m  #m make dot match newlines
  expect(page.body).to match(regexp)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/\s*,\s*/).each
  for rating in ratings
    if uncheck
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
    
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(page).to have_css("table#movies tbody tr", count: Movie.count)

end

# TODO: check, can we call step definition from other step definition? That would be DRYer
Then /I should (not )?see the following movies: (.*)/ do |invisible, movie_list|
  movies = movie_list.split(/,/)

  for movie in movies
    movie_clean = movie.strip[1..-2]
    # puts(movie_clean)
    if invisible
      if page.respond_to? :should
        expect(page).to have_no_content(movie_clean)
      else
        assert page.has_no_content?(movie_clean)
      end
    else
      if page.respond_to? :should
        expect(page).to have_content(movie_clean)
      else
        assert page.has_content?(movie_clean)
      end
    end
  end
end
