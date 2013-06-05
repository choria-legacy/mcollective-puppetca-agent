metadata :name => 'puppetca',
         :description => 'Checks the status of a puppet certificate',
         :author => 'Pieter Loubser <pieter.loubser@puppetlabs.com>',
         :license => 'ASL 2.0',
         :version => '1.0.0',
         :url => 'http://projects.puppetlabs.com/projects/mcollective-plugins/wiki',
         :timeout => 3

requires :mcollective => '2.2.1'

dataquery :description => 'Puppetca' do
  input :query,
        :prompt => 'Certificate name',
        :description => 'Certificate name',
        :type => :string,
        :validation => :shellsafe,
        :maxlength => 50

  output :status,
         :description => 'Has the cert been signed, is it awaiting signing or could it not be found.',
         :display_as => 'Cert Status'
end
