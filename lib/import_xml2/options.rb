class ImportXml2
  module Options

    VALID_OPTIONS = [:deduplicate]

    # Deduplicates results
    def option_deduplicate
      @results = @results.uniq
    end

  end
end
