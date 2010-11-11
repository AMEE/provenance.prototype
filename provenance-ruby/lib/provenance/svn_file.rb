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

  end
end