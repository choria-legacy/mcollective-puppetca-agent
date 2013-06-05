metadata    :name        => "puppetca",
            :description => "Agent to manage Puppet certificates",
            :author      => "R.I.Pienaar",
            :license     => "ASL 2.0",
            :version     => "3.0.0",
            :url         => "https://github.com/puppetlabs/mcollective-plugins",
            :timeout     => 20

requires :mcollective => '2.2.1'

action "clean", :description => "Performs a puppetca --clean on a certficate" do
    display :always

    input :certname,
          :prompt      => "Certificate Name",
          :description => "Certificate Name to clean",
          :type        => :string,
          :validation  => :shellsafe,
          :optional    => false,
          :maxlength   => 100

    output :out,
           :description => "Human readable status message",
           :display_as  => "Result"
end

action "revoke", :description => "Revokes a certificate by doing the same as clean" do
    display :always

    input :certname,
          :prompt      => "Certificate Name",
          :description => "Certificate Name to revoke",
          :type        => :string,
          :validation  => :shellsafe,
          :optional    => false,
          :maxlength   => 100

    output :out,
           :description => "Output from puppetca",
           :display_as  => "Result"
end

action "sign", :description => "Signs a certificate request" do
    input :certname,
          :prompt      => "Certificate Name",
          :description => "Certificate Name to sign",
          :type        => :string,
          :validation  => :shellsafe,
          :optional    => false,
          :maxlength   => 100

    output :out,
           :description => "Output from puppetca",
           :display_as  => "Result"
end

action "list", :description => "Lists all requested and signed certificates" do
    display :always

    output :requests,
           :description => "Waiting CSR Requests",
           :display_as  => "Waiting CSRs"

    output :signed,
           :description => "Signed Certificates",
           :display_as  => "Signed"
end

action "status", :description => "Find a certificate's status" do
    display :always

    input :certname,
          :prompt      => "Certificate Name",
          :description => "Certificate Name to lookup",
          :type        => :string,
          :validation  => :shellsafe,
          :optional    => false,
          :maxlength   => 100

    output :msg,
           :description => "Human readable status message",
           :display_as  => "Result"
end
