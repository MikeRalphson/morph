module Morph
  class Language
    def self.languages_supported
      [:ruby, :php, :python]
    end

    def self.human(language)
      t = {ruby: "Ruby", php: "PHP", python: "Python" }[language]
      raise "Unsupported language" if t.nil?
      t
    end

    # Defines our naming convention for the scraper of each language
    def self.language_to_file_extension(language)
      case language
      when :ruby
        "rb"
      when :php
        "php"
      when :python
        "py"
      end
    end

    # Name of the binary for running scripts of a particular language
    def self.binary_name(language)
      case language
      when :ruby
        "ruby"
      when :php
        "php"
      when :python
        "python"
      end
    end

    def self.language_to_scraper_filename(language)
      "scraper.#{language_to_file_extension(language)}" if language
    end

    # Find the language of the code in the given directory
    def self.language(repo_path)
      languages_supported.find do |language|
        File.exists?(File.join(repo_path, language_to_scraper_filename(language)))
      end
    end

    def self.main_scraper_filename(repo_path)
      language_to_scraper_filename(language(repo_path))
    end

    def self.scraper_command(language)
      "#{binary_name(language)} /repo/#{language_to_scraper_filename(language)}"
    end

    def self.language_supported?(language)
      languages_supported.include?(language)
    end

    def self.default_scraper(language)
      if language == :ruby
        <<-EOF
# This is a template for a Ruby scraper on Morph - https://morph.io
# Some example code snippets below that you should find helpful

# require 'scraperwiki'
# require 'mechanize'
# 
# agent = Mechanize.new
#
# # Read in a page 
# page = agent.get("http://foo.com")
#
# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")
#
# You don't have to do things with the Mechanize or ScraperWiki libraries. You can use whatever gems are installed
# on Morph for Ruby (https://github.com/openaustralia/morph-docker-ruby/blob/master/Gemfile) and all that matters
# is that your final data is written to an Sqlite database called data.sqlite in the current working directory which
# has at least a table called data.
        EOF
      else
        raise "Not yet supported"
      end
    end
  end
end