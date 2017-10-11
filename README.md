# Rooftop::AlgoliaSearch
Index and search your Rooftop post types in Algolia.

## Setup
To set up, you need:

* an [algolia.com](https://www.algolia.com) account
* an API key with permissions to write, update and delete items in the index - note that this [should not be your admin key](https://www.algolia.com/doc/guides/security/api-keys/?language=php#admin-api-key)
* an API key with permissions only to search
* your application ID
 
 ```ruby
    Rooftop::AlgoliaSearch.configure do |config|
      config.index_api_key = "your index api key"
      config.search_api_key = "your search api key"
      config.application_id = "your application id"
    end
```

## Use
Include `Rooftop::AlgoliaSearch` in your Rooftop models.