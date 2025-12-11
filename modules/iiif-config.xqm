(:~
 : Settings for generating a IIIF presentation manifest for a document.
 :)
module namespace iiifc="https://e-editiones.org/api/iiif/config";

import module namespace iiif="https://e-editiones.org/api/iiif" at "lib/api/iiif.xql";
import module namespace nav="http://www.tei-c.org/tei-simple/navigation" at "navigation.xql";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

(:~
 : Base URI of the IIIF image API service to use for the images
 :)
declare variable $iiifc:IMAGE_API_BASE := "https://apps.existsolutions.com/cantaloupe/iiif/2";

(:~
 : URL prefix to use for the canvas id
 :)
declare variable $iiifc:CANVAS_ID_PREFIX := "https://e-editiones.org/canvas/";


declare variable $iiifc:RESOURCES_CONFIG := map {
    "label": "p.",
    "default-prefix" : "LOC-ONB",
    "ONB": map {
        "IMAGE_API_BASE" : "https://api.onb.ac.at/iiif/image/v3/", 
        "CANVAS_ID_PREFIX": "https://api.onb.ac.at/iiif/presentation/v3/manifest/canvas/",
         "IMAGE_SUFFIX": ""
        },
    "NKP":  map {
        "IMAGE_API_BASE" : "https://imagines.manuscriptorium.com/loris/", 
        "CANVAS_ID_PREFIX": "https://collectiones.manuscriptorium.com/assorted/NKCR__/NKCR__/2/canvas/",
        "IMAGE_SUFFIX": "/full/0/default.jpg"
        },
    "LOC-ONB": map {
        "IMAGE_API_BASE" : iiif:link("/resources/facsimilies/onb/"), 
        "CANVAS_ID_PREFIX": iiif:link("/iiif/presentation/v1/manifest/canvas/")
        },
    "LOC-NKP": map {
        "IMAGE_API_BASE" : iiif:link("/resources/facsimilies/nkp/"),
        "CANVAS_ID_PREFIX":  iiif:link("/iiif/presentation/v1/manifest/canvas/")
        }
};


(:~
 : Return all milestone elements pointing to images, usually pb or milestone.
 :
 : @param $doc the document root node to scan
 :)
declare function iiifc:milestones($doc as node()) {
    $doc//tei:pb
};

(:
sample sourface element:
<surface xml:id="srf.nkp.misc.dec-2.lib-1.pb0025"
                  n="25">
            <graphic n="NKCR__-NKCR__22C000021DEC1DZU0B2-cs/IMG_MAIN_00000029"
                     xml:id="grph.onl.nkp.misc.dec-2.lib-1.pb0025"
                     url="https://imagines.manuscriptorium.com/loris/NKCR__-NKCR__22C000021DEC1DZU0B2-cs/IMG_MAIN_00000029/full/full/0/default.jpg"
                     corresp="https://imagines.manuscriptorium.com/loris/NKCR__-NKCR__22C000021DEC1DZU0B2-cs/IMG_MAIN_00000029"
                     width="2402px"
                     height="3736px"
                     type="online"/>
            <graphic xml:id="grph.loc.nkp.misc.dec-2.lib-1.pb0025"
                     source="https://imagines.manuscriptorium.com/loris/NKCR__-NKCR__22C000021DEC1DZU0B2-cs/IMG_MAIN_00000029/full/full/0/default.jpg"
                     corresp="https://imagines.manuscriptorium.com/loris/NKCR__-NKCR__22C000021DEC1DZU0B2-cs/IMG_MAIN_00000029"
                     url="../../facsimiles/misc.dec-2.lib-1/nkp/misc.dec-2.lib-1.pb0025.jpg"
                     width="2402px"
                     height="3736px"
                     type="local"/>
         </surface>
:)
(: sample milestone element:
 <pb n="25"
    xml:id="misc.dec-2.lib-1.pb0025"
    facs="ONB:grph.loc.onb.misc.dec-2.lib-1.pb0025 
        NKP:grph.loc.nkp.misc.dec-2.lib-1.pb0025 
        LOC-ONB:grph.loc.onb.misc.dec-2.lib-1.pb0025 
        LOC-NKP:grph.loc.nkp.misc.dec-2.lib-1.pb0025"/>
:)

(: sample output, local:
<milestone n="25"
           xml:id="misc.dec-2.lib-1.pb0025"
           local="true"
           prefix="LOC-ONB"
           id="grph.loc.onb.misc.dec-2.lib-1.pb0025"
           label="p."
           width="2324"
           height="3736"
           url="../../facsimiles/misc.dec-2.lib-1/onb/misc.dec-2.lib-1.pb0025.jpg"/>

online:
<milestone n="25"
           xml:id="misc.dec-2.lib-1.pb0025"
           local="false"
           prefix="ONB"
           id="grph.onl.onb.misc.dec-2.lib-1.pb0025"
           label="p."
           width="2324"
           height="3736"
           corresp="https://api.onb.ac.at/iiif/image/v3/1066B32A/uk4nGb4kRnjk8fjF"
           url="https://api.onb.ac.at/iiif/image/v3/1066B32A/uk4nGb4kRnjk8fjF/full/max/0/default.jpg"/>

:)

(:~
 : Extract the image path from the milestone element. If you need to strip
 : out or add something, this is the place. By default strips any prefix before a colon.
 : @param $milestone the milestone element
 : @param $surfaces the list of surface elements in the facsimile
 : @return the milestone element with prefix, id (ie. path) and 
 : IMAGE_API_BASE and CANVAS_ID_PREFIX attributes for remote resources,
 : or IMAGE_URL_BASE for local resources
  :)
declare function iiifc:milestone-id($milestone as element(), $surfaces as element()*) {
    let $facsimilies := tokenize($milestone/@facs)[.]
    let $facsimile := head(($facsimilies[starts-with(., $iiifc:RESOURCES_CONFIG("default-prefix") || ":")], $facsimilies[1]
    ))
    let $prefix := substring-before($facsimile, ":")
    let $is-local := starts-with($prefix, "LOC-")
    let $id := substring-after($facsimile, ":")
    let $graphic := $surfaces/id($id)
    return
    (
    <milestone n="{$milestone/@n}" xml:id="{$milestone/@xml:id}" local="{$is-local}" prefix="{$prefix}" id="{$id}" label="{$iiifc:RESOURCES_CONFIG?label}">
            {(
                if($graphic) then 
                (   attribute width { iiifc:extent-as-number($graphic/@width) },
                    attribute height { iiifc:extent-as-number($graphic/@height) }
                )
                else (),
                if($is-local) then $graphic/@url else ($graphic/@corresp, $graphic/@url),
                (attribute IMAGE_API_BASE { $iiifc:RESOURCES_CONFIG($prefix)?IMAGE_API_BASE },
                     attribute CANVAS_ID_PREFIX { $iiifc:RESOURCES_CONFIG($prefix)?CANVAS_ID_PREFIX }
                )
            )
            }
    </milestone>)
 };

declare function iiifc:extent-as-number($extent) {
 replace($extent, "^(\d+)(.*)", "$1")
};


(:~
 : Provide general metadata fields for the object. The result will be merged into the
 : root of the presentation manifest. 
 :)
declare function iiifc:metadata($doc as element(), $id as xs:string) as map(*) {
    map {
        "label": nav:get-metadata($doc, "title")/string(),
        "metadata": [
            map { "label": "Title", "value": nav:get-metadata($doc, "title")/string() },
            map { "label": "Creator", "value": nav:get-metadata($doc, "author")/string() },
            map { "label": "Language", "value": nav:get-metadata($doc, "language") },
            map { "label": "Date", "value": nav:get-metadata($doc, "date")/string() }
        ],
        "license": nav:get-metadata($doc, "license"),
        "rendering": [
            map {
                "@id": iiif:link("print/" || encode-for-uri($id)),
                "label": "Print preview",
                "format": "text/html"
            },
            map {
                "@id": iiif:link("api/document/" || encode-for-uri($id) || "/epub"),
                "label": "ePub",
                "format": "application/epub+zip"
            }
        ]
    }
};