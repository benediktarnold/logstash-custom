# My custom logstash plugins

## Filters

### disjoin

This filter clones an event based on attributes. It creates a clone for each attribute you configure in *includes* 
If your *includes* contains two attributes, the filter generates two new events. Each containing one of the attributes.

Canceling the original event is optional.

	input {
		generator {
	    	add_field => {
	    		"field1" => "foo"
	    		"field2" => "bar"
	    		"field3" => "ignore this attribute"
	    	}
	    	count => 1
	  	}
	}
	filter {
	    disjoin {
	      includes => ["field1", "field2"]
	      cancel => true
	    }
	}
	output {
	  stdout { codec => rubydebug }
	}

