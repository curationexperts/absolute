var workType = "";
var dublinCore = {
  title: "",
  creator: "",
  contributor: "",
  description: "",
  subject: "",
  date: "",
  publisher: "",
  coverage: "",
  source: "",
  language: "",
  type: "",
  identifier: "",
  format: ""
};

// TODO: Add code to handle additional schemas like extended dublin core (dc:temporal)

// Find the type of work to make sure that you are not adding multiple values to singel fields
function getWorkType(){
  var path = window.location.pathname;
  if(path.indexOf("concern/texts") > -1){workType = "text"; }
  if(path.indexOf("concern/images") > -1){ workType = "image"; }
  if(path.indexOf("concern/audios") > -1){ workType = "audio"; }
  if(path.indexOf("concern/videos") > -1){ workType = "video"; }
  if(path.indexOf("concern/case_generic_works") > -1){ workType = "case_generic_work"; }
  if(path.indexOf("collection") > -1){ workType = "collection"; }
}

function addValues(data){
  for(var i = 0;i < data.values.length;i++){
    data.fields[data.fields.length-1].getElementsByTagName(data.input)[0].value = data.values[i].childNodes[0].wholeText;
    if(workType !== "collection"){ data.fields[data.fields.length-1].getElementsByTagName("button")[0].click(); }
  }
}

// For title and description on collections there is only one possible field
// Looking for li elements will return an empty set causing an error
function getFields(key){
  if(workType === "collection" && (key === "title" || key === "description")){
    return document.getElementsByClassName("collection_" + key);
  } else {
    return document.getElementsByClassName(workType + "_" + (key === "format" ? "content_" : "" ) + key )[0].getElementsByTagName("li");
  }
}

function extractDC(xmldoc){
  getWorkType();

  for(var key in dublinCore){
    if(dublinCore.hasOwnProperty(key)){
      dublinCore[key] = {
        values: xmldoc.getElementsByTagName(key),
        fields: getFields(key),
        input: key === "description" ? "textarea" : "input"
      };
      addValues(dublinCore[key]);
    }
  }

  document.getElementById("drop-area").innerHTML = "File Loaded";
}


function parseXML(file){
  if(window.DOMParser){
    var parser = new DOMParser();
    var xmldoc = parser.parseFromString(file, 'application/xml');
    extractDC(xmldoc);
  } else {
    var xmldoc = new ActiveXObject("Microsoft.XMLDOM");
    xmldoc.async = false;
    xmldoc.loadxml(file);
    extractDC(xmldoc);
  }
}

function getFile(){
  var reader = new FileReader();
  reader.readAsText(files[0]);
  reader.onload = function(){ parseXML(reader.result); };
}
