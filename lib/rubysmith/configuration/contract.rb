# frozen_string_literal: true

require "dry/schema"
require "etcher"

Dry::Schema.load_extensions :monads

module Rubysmith
  module Configuration
    Contract = Dry::Schema.Params do
      optional(:author_email).filled :string
      optional(:author_family_name).filled :string
      optional(:author_given_name).filled :string
      required(:author_handle).filled :string
      required(:author_uri).filled :string
      required(:build_amazing_print).filled :bool
      required(:build_bootsnap).filled :bool
      required(:build_caliber).filled :bool
      required(:build_circle_ci).filled :bool
      required(:build_citation).filled :bool
      required(:build_cli).filled :bool
      required(:build_community).filled :bool
      required(:build_conduct).filled :bool
      required(:build_console).filled :bool
      required(:build_contributions).filled :bool
      required(:build_dcoo).filled :bool
      required(:build_debug).filled :bool
      required(:build_funding).filled :bool
      required(:build_git).filled :bool
      required(:build_git_hub).filled :bool
      required(:build_git_hub_ci).filled :bool
      required(:build_git_lint).filled :bool
      required(:build_guard).filled :bool
      required(:build_irb_kit).filled :bool
      required(:build_license).filled :bool
      required(:build_maximum).filled :bool
      required(:build_minimum).filled :bool
      required(:build_rake).filled :bool
      required(:build_readme).filled :bool
      required(:build_reek).filled :bool
      required(:build_refinements).filled :bool
      required(:build_rspec).filled :bool
      required(:build_rtc).filled :bool
      required(:build_security).filled :bool
      required(:build_setup).filled :bool
      required(:build_simple_cov).filled :bool
      required(:build_versions).filled :bool
      required(:build_zeitwerk).filled :bool
      optional(:citation_affiliation).filled :string
      optional(:citation_message).filled :string
      optional(:citation_orcid).filled :string
      required(:documentation_format).filled :string
      required(:loaded_at).filled :time
      required(:license_label).filled :string
      required(:license_name).filled :string
      required(:license_version).filled :string
      optional(:organization_label).filled :string
      required(:organization_uri).filled :string
      optional(:project_name).filled :string
      optional(:project_uri_community).filled :string
      optional(:project_uri_conduct).filled :string
      optional(:project_uri_contributions).filled :string
      optional(:project_uri_dcoo).filled :string
      optional(:project_uri_download).filled :string
      optional(:project_uri_funding).filled :string
      optional(:project_uri_home).filled :string
      optional(:project_uri_issues).filled :string
      optional(:project_uri_license).filled :string
      optional(:project_uri_security).filled :string
      optional(:project_uri_source).filled :string
      optional(:project_uri_versions).filled :string
      required(:project_version).filled :string
      required(:repository_handle).filled :string
      required(:repository_uri).filled :string
      required(:target_root).filled Etcher::Types::Pathname
      optional(:template_path).filled Etcher::Types::Pathname
      required(:template_roots).array Etcher::Types::Pathname
    end
  end
end
