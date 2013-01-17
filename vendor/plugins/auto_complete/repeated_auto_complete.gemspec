# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{repeated_auto_complete}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Shaughnessy"]
  s.date = %q{2010-03-01}
  s.description = %q{auto_complete plugin refactored to handle complex forms and named scopes}
  s.email = %q{pat@patshaughnessy.net}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/auto_complete.rb",
     "lib/auto_complete_form_builder_helper.rb",
     "lib/auto_complete_macros_helper.rb",
     "lib/repeated_auto_complete.rb",
     "lib/view_mapper/README",
     "lib/view_mapper/has_many_auto_complete_view.rb",
     "lib/view_mapper/templates/controller.rb",
     "lib/view_mapper/templates/layout.html.erb",
     "lib/view_mapper/templates/style.css",
     "lib/view_mapper/templates/view_child_form.html.erb",
     "lib/view_mapper/templates/view_form.html.erb",
     "rails/init.rb",
     "repeated_auto_complete.gemspec",
     "test/auto_complete_form_builder_helper_test.rb",
     "test/auto_complete_nested_attributes_test.rb",
     "test/auto_complete_test.rb",
     "test/helper.rb",
     "test/view_mapper/expected_templates/_form.html.erb",
     "test/view_mapper/expected_templates/_person.html.erb",
     "test/view_mapper/expected_templates/create_parents.rb",
     "test/view_mapper/expected_templates/edit.html.erb",
     "test/view_mapper/expected_templates/index.html.erb",
     "test/view_mapper/expected_templates/new.html.erb",
     "test/view_mapper/expected_templates/parent.rb",
     "test/view_mapper/expected_templates/show.html.erb",
     "test/view_mapper/expected_templates/testies_controller.rb",
     "test/view_mapper/has_many_auto_complete_view_test.rb"
  ]
  s.homepage = %q{http://patshaughnessy.net/repeated_auto_complete}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{auto_complete plugin refactored to handle complex forms and named scopes}
  s.test_files = [
    "test/auto_complete_form_builder_helper_test.rb",
     "test/auto_complete_nested_attributes_test.rb",
     "test/auto_complete_test.rb",
     "test/helper.rb",
     "test/view_mapper/expected_templates/create_parents.rb",
     "test/view_mapper/expected_templates/parent.rb",
     "test/view_mapper/expected_templates/testies_controller.rb",
     "test/view_mapper/has_many_auto_complete_view_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
