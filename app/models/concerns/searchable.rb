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
        indexes :hosting, type: 'string', analyzer: 'ngram_analyzer'
        indexes :owner, type: 'string', analyzer: 'ngram_analyzer'
        indexes :repo, type: 'string', analyzer: 'ngram_analyzer'
      end
    end
  end

  def as_indexed_json(options = {})
    as_json(options.merge(root: false)).merge('path' => path.to_s)
  end
end
