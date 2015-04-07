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

  // Get each of the elements of the form for adding content
  title = document.getElementsByClassName("text_title")[0].getElementsByTagName("li");
  creator = document.getElementsByClassName("text_creator")[0].getElementsByTagName("li");
  contributor = document.getElementsByClassName("text_contributor")[0].getElementsByTagName("li");
  description = document.getElementsByClassName("text_description")[0].getElementsByTagName("li");
  subject = document.getElementsByClassName("text_subject")[0].getElementsByTagName("li");
  date = document.getElementsByClassName("text_date")[0].getElementsByTagName("li");
  publisher = document.getElementsByClassName("text_publisher")[0].getElementsByTagName("li");
  coverage = document.getElementsByClassName("text_coverage")[0].getElementsByTagName("li");
  source = document.getElementsByClassName("text_source")[0].getElementsByTagName("li");
  language = document.getElementsByClassName("text_language")[0].getElementsByTagName("li");
  type = document.getElementsByClassName("text_type")[0].getElementsByTagName("li");
  identifier = document.getElementsByClassName("text_identifier")[0].getElementsByTagName("li");
  format = document.getElementsByClassName("text_content_format")[0].getElementsByTagName("li");

  // Add the items from the XML document into the form
  for(var i = 0;i < xmlTitle.length;i++){
    title[title.length-1].getElementsByTagName("input")[0].value = xmlTitle[i].childNodes[0].wholeText;	// Title is single Valued, multiple values are combined
    title[title.length-1].getElementsByTagName("button")[0].click();
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
    description[description.length-1].getElementsByTagName("button")[0].click();
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
