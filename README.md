# CSV to JSON Parser
### Java, PERL, Python, GO, Javascript shootout

### Requirements
* Interpreters:
  * PERL, Python and node
* Go environment set up
  * Need to have GOPATH and GOROOT
* Java Environment set up
  * JAVA_HOME and CLASSPATH

### Description
* Read CSV file
* Use headers as keys
* Read Each Row transform to map/dictionary assigning header as key and current row column as value
* trim white space, EOL characters and double quote string for JSON
* add map/dictionary to List
* wrap list as object and output json

### Test script
* Execute each program piped to python json.tool to validate
* Use time to execute each program.

### Presentation of Results
* scrape log and tranform time output using awk/sed into JSON, output to file
* launch python SimpleHTTPServer
* open index.html
* let results.js request the speed output file and generate web Contents
* shell script pauses for use to hit Enter and kill the server 
