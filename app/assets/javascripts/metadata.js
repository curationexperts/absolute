function extractDC(xmldoc){
  xmlTitle = xmldoc.getElementsByTagName("title");
  xmlCreator = xmldoc.getElementsByTagName("creator");
  xmlContributor = xmldoc.getElementsByTagName("contributor");
  xmlDescription = xmldoc.getElementsByTagName("description");
  xmlSubject = xmldoc.getElementsByTagName("subject");
  xmlDate = xmldoc.getElementsByTagName("date");
  xmlTemporal = xmldoc.getElementsByTagName("temporal");	// This is needed to handle the dcterms:temporal value, but is converted to dc:date
  xmlPublisher = xmldoc.getElementsByTagName("publisher");
  xmlCoverage = xmldoc.getElementsByTagName("coverage");
  xmlSource = xmldoc.getElementsByTagName("source");
  xmlLanguage = xmldoc.getElementsByTagName("language");
  xmlType = xmldoc.getElementsByTagName("type");
  xmlIdentifier = xmldoc.getElementsByTagName("identifier");
  xmlFormat = xmldoc.getElementsByTagName("format");

  // Find out what type of work we have to get the correct element names
  var path = window.location.pathname;
  var workType = "";
  if(path.indexOf("concern/texts") > -1){workType = "text"; }
  if(path.indexOf("concern/images") > -1){ workType = "image"; }
  if(path.indexOf("concern/audios") > -1){ workType = "audio"; }
  if(path.indexOf("concern/videos") > -1){ workType = "video"; }
  if(path.indexOf("concern/case_generic_works") > -1){ workType = "case_generic_work"; }
  if(path.indexOf("collection") > -1){ workType = "collection"; }
  // Get each of the elements of the form for adding content
  if(workType == "collection"){
    title = document.getElementsByClassName("collection_title");
    description = document.getElementsByClassName("collection_description");
  } else {
    title = document.getElementsByClassName(workType + "_title")[0].getElementsByTagName("li");
    description = document.getElementsByClassName(workType + "_description")[0].getElementsByTagName("li");
  }
  creator = document.getElementsByClassName(workType + "_creator")[0].getElementsByTagName("li");
  contributor = document.getElementsByClassName(workType + "_contributor")[0].getElementsByTagName("li");
  subject = document.getElementsByClassName(workType + "_subject")[0].getElementsByTagName("li");
  date = document.getElementsByClassName(workType + "_date")[0].getElementsByTagName("li");
  publisher = document.getElementsByClassName(workType + "_publisher")[0].getElementsByTagName("li");
  coverage = document.getElementsByClassName(workType + "_coverage")[0].getElementsByTagName("li");
  source = document.getElementsByClassName(workType + "_source")[0].getElementsByTagName("li");
  language = document.getElementsByClassName(workType + "_language")[0].getElementsByTagName("li");
  type = document.getElementsByClassName(workType + "_type")[0].getElementsByTagName("li");
  identifier = document.getElementsByClassName(workType + "_identifier")[0].getElementsByTagName("li");
  format = document.getElementsByClassName(workType + "_content_format")[0].getElementsByTagName("li");

  // Add the items from the XML document into the form
  for(var i = 0;i < xmlTitle.length;i++){
    title[title.length-1].getElementsByTagName("input")[0].value = xmlTitle[i].childNodes[0].wholeText;	// Title is single Valued, multiple values are combined
    if(workType != "collection"){ title[title.length-1].getElementsByTagName("button")[0].click(); }
  }
  for(var i = 0;i < xmlCreator.length;i++){
    creator[creator.length-1].getElementsByTagName("input")[0].value = xmlCreator[i].childNodes[0].wholeText;
    creator[creator.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlContributor.length;i++){
    contributor[contributor.length-1].getElementsByTagName("input")[0].value = xmlContributor[i].childNodes[0].wholeText;
    contributor[contributor.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlDescription.length;i++){
    description[description.length-1].getElementsByTagName("textarea")[0].value = xmlDescription[i].childNodes[0].wholeText;	// Description is single valued
    if(workType != "collection"){ description[description.length-1].getElementsByTagName("button")[0].click(); }
  }
  for(var i = 0;i < xmlSubject.length;i++){
    subject[subject.length-1].getElementsByTagName("input")[0].value = xmlSubject[i].childNodes[0].wholeText;
    subject[subject.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlDate.length;i++){
    date[date.length-1].getElementsByTagName("input")[0].value = xmlDate[i].childNodes[0].wholeText;
    date[date.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlTemporal.length;i++){
    date[date.length-1].getElementsByTagName("input")[0].value = xmlTemporal[i].childNodes[0].wholeText;
    date[date.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlPublisher.length;i++){
    publisher[publisher.length-1].getElementsByTagName("input")[0].value = xmlPublisher[i].childNodes[0].wholeText;
    publisher[publisher.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlCoverage.length;i++){
    coverage[coverage.length-1].getElementsByTagName("input")[0].value = xmlCoverage[i].childNodes[0].wholeText;
    coverage[coverage.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlSource.length;i++){
    source[source.length-1].getElementsByTagName("input")[0].value = xmlSource[i].childNodes[0].wholeText;
    source[source.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlLanguage.length;i++){
    language[language.length-1].getElementsByTagName("input")[0].value = xmlLanguage[i].childNodes[0].wholeText;
    language[language.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlType.length;i++){
    type[type.length-1].getElementsByTagName("input")[0].value = xmlType[i].childNodes[0].wholeText;
    type[type.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlIdentifier.length;i++){
    identifier[identifier.length-1].getElementsByTagName("input")[0].value = xmlIdentifier[i].childNodes[0].wholeText;
    identifier[identifier.length-1].getElementsByTagName("button")[0].click();
  }
  for(var i = 0;i < xmlFormat.length;i++){
    format[format.length-1].getElementsByTagName("input")[0].value = xmlFormat[i].childNodes[0].wholeText;
    format[format.length-1].getElementsByTagName("button")[0].click();
  }
  document.getElementById("drop-area").innerHTML = "File Loaded";
}

function parseXML(file){
  if(window.DOMParser){
    parser = new DOMParser();
    xmldoc = parser.parseFromString(file, 'application/xml');
    extractDC(xmldoc);
  } else {
    xmldoc = new ActiveXObject("Microsoft.XMLDOM");
    xmldoc.async = false;
    xmldoc.loadxml(file);
    extractDC(xmldoc);
  }
}

function getFile(){
  reader = new FileReader();
  reader.readAsText(files[0]);
  reader.onload = function(){ parseXML(reader.result); }
}
