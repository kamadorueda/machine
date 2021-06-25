_: with _; {
  # defaultSearchProviderSearchURL =
  #   "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
  # defaultSearchProviderSuggestURL =
  #   "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
  enable = true;
  extensions = [
    "glnpjglilkicbckjpbgcfkogebgllemb" # okta
    "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
  ];
  # https://chromeenterprise.google/policies/
  extraOpts = { };
}
