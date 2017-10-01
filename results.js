class Results {
  constructor() {
    this._speedData = {};
    this._code = {};
  }

  get speedData() {
    return this._speedData;
  }
  set speedData(s) {
    this._speedData = s;
  }

  get code() {
    return this_code;
  };

  getSpeedResults() {
    //let _offset = (offset) ? offset : 0;
    let url = 'http://localhost:8000/speed.json';
    return new Promise((resolve, reject) => {
      let xhr = new XMLHttpRequest();
      xhr.open('GET', url);
      xhr.send();
      xhr.onload = () => {
        if (xhr.status == 200) {
          this._speedData = JSON.parse(xhr.response);
          resolve(this._speedData);
        } else {
          reject({status: this.status, statusText: xhr.statusText});
        }
      };
      xhr.onerror = () => {
        reject({status: this.status, statusText: xhr.statusText});
      };
    });
  }

  display() {
    let report = document.createElement('report');
    report.style = "display: flex;flex-wrap: wrap;flex-direction: row";
    for (let k of Object.keys(this.speedData)) {
      document.createElement('div')
      let d = document.createElement('div');
      d.id = k;
      d.style.width = '150px';
      d.style.font = "1.375em bold"
      d.style.color = "white";
      d.textContent = k;
      d.className = 'lang';
      d.style.backgroundColor = 'blue';
      d.style.margin = "5px 5px 5px 5px";
      d.style.padding = "5px 5px 5px 5px";

      for (let j of Object.keys(this.speedData[k])) {
        let d1 = document.createElement('div')
        d1.id = k + j
        d1.style.font = ".80em italic"
        d1.style.color = "black";
        d1.textContent = `${j}:${this.speedData[k][j]}`;
        d1.className = 'time';
        d1.style.backgroundColor = 'yellow';
        d1.style.border = 'solid black 1px';
        d.appendChild(d1);
      }
      report.appendChild(d)
      document.body.appendChild(report);
    }
  }
}
var app = new Results();
app.getSpeedResults().then((resolve) => {
  //app.speedData = resolve.data;
  app.display();
},(reject) => {console.log(reject.status)});
