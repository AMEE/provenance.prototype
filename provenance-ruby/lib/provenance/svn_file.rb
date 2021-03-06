module Prov
  class SvnFile < TextFile

    attr_reader :repo,:relative

    def initialize(repo,path)
      super(File.new(File.join(repo.svn_repo_working_copy,path)))
      @repo=repo
      @relative=path
    end

    def url
      File.join(repo.svn_repo_master,relative)
    end

    def first_author
      #should be able to use the svn_wc lib for this, but doesn't support it
      # so use shell command
      `svn log #{path} --quiet #{Connection::Subversion.auth_options}| grep r | gawk '{print $3}' | tail -n1`.chop
    end

    def last_author
      `svn log #{path} --quiet #{Connection::Subversion.auth_options}| grep r | gawk '{print $3}' | head -n1`.chop
    end
    def author
      "mailto:#{last_author}@amee.com"
    end

  end
end