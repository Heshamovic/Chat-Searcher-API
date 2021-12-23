#! /bin/bash

rails runner 'Station.create(…)'
Application.__elasticsearch__.create_index!
Message.__elasticsearch__.create_index!
Chat.__elasticsearch__.create_index!
puts "Indices created"
