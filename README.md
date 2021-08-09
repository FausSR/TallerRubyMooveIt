# TallerRubyMooveIt

## Memcached server

To run the memcached server you have to run: "ruby index.rb".

## Client

You can run a client demo using the following command "ruby .index_client.rb".
When the connection is established, only start writing in the terminal some of the valid commands, for example:

set test 0 0 4  |  test

get test

gets test

cas test 0 0 12 1  |  updated_test

append test 0 0 5  |  right

prepend test 0 0 4  |  left

add test1 0 0 5  |  test1

replace test1 0 0 13  |  replaced_test


## Testing

To run all the tests, run "rspec --pattern test/*.rb".
To test a specific class run the next command "rspec ./test/the_class_you_want_to_test.rb". For example "rspec .test/command_set_spec.rb".
