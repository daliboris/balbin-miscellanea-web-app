
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-balbin-web="http://www.tei-c.org/pm/models/balbin/web/module" at "../transform/balbin-web-module.xql";
import module namespace pm-balbin-print="http://www.tei-c.org/pm/models/balbin/print/module" at "../transform/balbin-print-module.xql";
import module namespace pm-balbin-fo="http://www.tei-c.org/pm/models/balbin/fo/module" at "../transform/balbin-fo-module.xql";
import module namespace pm-balbin-latex="http://www.tei-c.org/pm/models/balbin/latex/module" at "../transform/balbin-latex-module.xql";
import module namespace pm-balbin-epub="http://www.tei-c.org/pm/models/balbin/epub/module" at "../transform/balbin-epub-module.xql";
import module namespace pm-teipublisher-web="http://www.tei-c.org/pm/models/teipublisher/web/module" at "../transform/teipublisher-web-module.xql";
import module namespace pm-teipublisher-print="http://www.tei-c.org/pm/models/teipublisher/print/module" at "../transform/teipublisher-print-module.xql";
import module namespace pm-teipublisher-fo="http://www.tei-c.org/pm/models/teipublisher/fo/module" at "../transform/teipublisher-fo-module.xql";
import module namespace pm-teipublisher-latex="http://www.tei-c.org/pm/models/teipublisher/latex/module" at "../transform/teipublisher-latex-module.xql";
import module namespace pm-teipublisher-epub="http://www.tei-c.org/pm/models/teipublisher/epub/module" at "../transform/teipublisher-epub-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "balbin.odd" return pm-balbin-web:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-web:transform($xml, $parameters)
    default return pm-balbin-web:transform($xml, $parameters)
            

};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "balbin.odd" return pm-balbin-print:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-print:transform($xml, $parameters)
    default return pm-balbin-print:transform($xml, $parameters)
            

};
            


declare variable $pm-config:fo-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "balbin.odd" return pm-balbin-fo:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-fo:transform($xml, $parameters)
    default return pm-balbin-fo:transform($xml, $parameters)
            

};
            


declare variable $pm-config:latex-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "balbin.odd" return pm-balbin-latex:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-latex:transform($xml, $parameters)
    default return pm-balbin-latex:transform($xml, $parameters)
            

};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "balbin.odd" return pm-balbin-epub:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-epub:transform($xml, $parameters)
    default return pm-balbin-epub:transform($xml, $parameters)
            

};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")

};
            
    