class test1{                                          
        file { "/tmp/new.txt":                      
        content => "Hello Everyone!";       
        }
        
        file { "/tmp/new2.txt":                   
        content => "tianyun";                   
        }
}
