package main

import (
    "fmt"
    "strings"
    "os"
    "bufio"
    "io"
    "bytes"
    "regexp"
    "strconv"
)

const filename string = "./testdata.txt"
func scrubQuote(s string) string {
  clean:=strings.Trim(s, " ")
  re1:=regexp.MustCompile(`\"`)
  clean = re1.ReplaceAllString(clean,"")
  re2:=regexp.MustCompile(`\\r\\n`)
  clean = re2.ReplaceAllString(clean,"")
  re3:=regexp.MustCompile(`\\n`)
  clean =re3.ReplaceAllString(clean,"")
  clean = strconv.Quote(clean)
  return clean
}
func formatOutput(records []map[string]interface{}) {
  var final []string
  var buffer bytes.Buffer
  for _, element := range records  {
    var pairs []string
    for k,v := range element {
      buffer.Reset()
      buffer.WriteString(k)
      buffer.WriteString(":")
      buffer.WriteString(v.(string))
      pairs = append(pairs,buffer.String())
    }
    rec:=strings.Join(pairs[:],",")
    buffer.Reset()
    buffer.WriteString("  {")
    buffer.WriteString(rec)
    buffer.WriteString("}")
    final = append(final,buffer.String())

  }
  recs:=strings.Join(final[:],",\n")
  fmt.Printf("{\n  \"payload\":[%s\n  ]\n}\n", recs)
}

func readFile() (err error) {
    file, err := os.Open(filename)
    defer file.Close()
    if err != nil {
        return err
    }
    // Start reading from the file with a reader.
    reader := bufio.NewReader(file)
    var records []map[string]interface{}
    records = make([]map[string]interface{},0,0)
    var count int
    var headers []string
    count=0
    for {
        var buffer bytes.Buffer
        var l []byte
        var isPrefix bool
        for {
            l, isPrefix, err = reader.ReadLine()
            buffer.Write(l)
            // EOL
            if !isPrefix {
                break
            }
            // EOF
            if err != nil {
                break
            }
        }
        if err == io.EOF {
            break
        }
        line := buffer.String()

        if count==0 { //header
          headers=strings.Split(line, ",")
          count++ //don't care after this
          continue
        } else {
          rec:=strings.Split(line, ",")
          var m map[string]interface{}
          m = make(map[string]interface{})
          for index, element := range headers {
            m[scrubQuote(element)]=scrubQuote(rec[index])
          }
          records = append(records, m)
        }
    }

    if err != io.EOF {
      fmt.Printf(" > Error : %v\n", err)
    }
    formatOutput(records)
    return
}
func main() {
  readFile()
}
