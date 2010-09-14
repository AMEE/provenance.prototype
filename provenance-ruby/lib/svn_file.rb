
class SvnFile < TextFile

  attr_reader :repo,:path

  def initialize(repo,path)
    super(File.new(File.join(repo.svn_repo_working_copy,path)))
    @repo=repo
    @path=path
  end

  def url
    File.join(repo.svn_repo_master,path)
  end

end
