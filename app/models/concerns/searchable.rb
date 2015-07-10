module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "docrystal-#{Rails.env}"

    settings(
      index: {
        analysis: {
          filter: {
            greek_lowercase_filter: {
              type:     'lowercase',
              language: 'greek',
            },
          },
          tokenizer: {
            ngram_tokenizer: {
              type: 'nGram',
              min_gram: '2',
              max_gram: '3',
              token_chars: ['letter', 'digit']
            }
          },
          analyzer: {
            ngram_analyzer: {
              tokenizer: 'ngram_tokenizer',
              filter:    ['greek_lowercase_filter'],
            }
          }
        }
      }
    ) do
      mapping do
        indexes :id, type: 'integer', index: 'not_analyzed'
        indexes :path, type: 'string', analyzer: 'ngram_analyzer'
      end
    end
  end
end
