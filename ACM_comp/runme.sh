#!/bin/bash -e                                                                                                                                                                                      

# Remove because is was baked in here stale                                                                                                                                                        
if [ -d ~/Examples ]; then 
    sudo rm -r ~/Examples
fi

# Get the new code                                                                                                                                                                                  
git clone git://github.com/koooee/BigDataR_Examples.git ~/Examples

# run all the steps                                                                                                                                                                                 
for i in {1..5}; do pushd ~/Examples/ACM_comp/step${i}*/; ./runme.sh; popd; done
