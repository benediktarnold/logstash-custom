# My custom logstash plugins

## Filters

### disjoin

This filter clones an event based on attributes. It creates a clone for each attribute you configure in *includes* 
If your *includes* contains two attributes, the filter generates two new events. Each containing one of the attributes.

Canceling the original event is optional.

#### Example

This example configuration generates one event with three fields. Field1 and field2 should be included in the disjoin events. The original event will be droped.

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

#### Output
	{
	       "message" => "Hello world!",
	      "@version" => "1",
	    "@timestamp" => "2014-10-31T13:12:15.062Z",
	        "field1" => "foo",
	        "field3" => "ignore this attribute",
	          "host" => "subethabook.local",
	      "sequence" => 0
	}
	{
	       "message" => "Hello world!",
	      "@version" => "1",
	    "@timestamp" => "2014-10-31T13:12:15.062Z",
	        "field2" => "bar",
	        "field3" => "ignore this attribute",
	          "host" => "subethabook.local",
	      "sequence" => 0
	}
