'use strict';
//imports
const fs = require('fs');
const readline = require('readline');
//static
const FILE = './testdata.txt';
//test files
//const fileName = './no-file';
//const fileName = './emptyfile.txt';
//const fileName = './fieldimbalance.txt';
//instance
class CSVParser {

  constructor(file=FILE) {
    this._fileName = file;
    this._payload = [];
    this._headers = [];
    this._lines = [];
  }
  //props
  get fileName() {
    return this._fileName;
  }
  set fileName(fileName) {
    this._fileName = fileName;
  }
  get headers() {
    return this._headers;
  };
  set headers(h) {
    this._headers = h;
  }
  get payload() {
    return this._payload;
  };
  set payload(payload) {
    this._headers = payload;
  }
  get lines() {
    return this._lines;
  };
  set lines(lines) {
    this._lines = lines;
  }
  //methods
  scrub(fields) {
    let clean = [];
    clean = fields.map(el => {
      el = el.trim();
      el = el.replace(/\"/g, '');
      el = el.replace(/\\r\\n/, '');
      el = el.replace(/\\n/, '');
      return el;
    })
    return clean;
  }

  splitLoad(type, line, i) {
    let fields = line.split(",");
    if ( this.headers.length !== 0 && this.headers.length != fields.length ) {
      throw new Error(`FieldCountImbalanceException: at line #${i}\n\n${line}\n\n`);
    }
    fields = this.scrub(fields);
    if (type == 0) {
      this.headers = fields;
    } else if (type == 1) {
      let recordMap = {};
      for (let i in this.headers) {
        recordMap[this.headers[i]] = fields[i];
      }
      this.payload.push(recordMap);
    }
  }

  processLines() {
    if (this.lines.length < 1) throw new Error("FileEmptyException");
    for (let i in this.lines) {
      if (i == 0) {
        this.splitLoad(0, this.lines[i]);
      } else {
        this.splitLoad(1, this.lines[i],i);
      }
    }
    return this.lines.length;
  }
  //async
  readFileByLine() {
    let x;
    return new Promise((resolve, reject) => {
      var reader;
      if (!fs.existsSync(this.fileName)) {
        console.log('FileNotFoundException: ' + this.fileName);
        reject({status: 'failed', err: 'IO Error'});
        return;
      }
      reader = readline.createInterface({input: fs.createReadStream(this.fileName)});
      let lines = [];
      reader.on('line', (line) => {
        lines.push(line);
      });
      reader.on('close', () => {
        this.lines = lines;
        resolve({status: 'complete', length: this.lines.length});
      });
    });
  }
}
let c = new CSVParser();
c.readFileByLine().then((resolve, reject) => {
  try {
    c.processLines(resolve.length);
  } catch (err) {
    console.log(err);
  }
  let obj = new Object();
  obj.payload = c.payload;
  console.log(JSON.stringify(obj));
}, () => {
  console.log(reject);
}).catch((e) => {
  throw e
});
