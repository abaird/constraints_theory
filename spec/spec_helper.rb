require_relative '../load_lib'
require 'constraints_theory'

def mock_io(in_str)
  old_stdin, old_stdout = $stdin, $stdout
  $stdin = StringIO.new(in_str)
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdin, $stdout = old_stdin, old_stdout
end
