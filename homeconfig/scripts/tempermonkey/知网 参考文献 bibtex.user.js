// ==UserScript==
// @name         知网 参考文献 bibtex
// @namespace    https://github.com/zheng-oh
// @require      https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js
// @version      1.1.1
// @description  从知网文献中直接复制bibtex
// @author       zxing
// @match        https://kns.cnki.net/kcms/detail/detail.aspx?dbcode=*
// @match        http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    jQuery(document).ready(function($) {

        window.onload = function(){

            var a = document.getElementById("paramdbname")
            var b = document.getElementById("paramfilename")
            var fileid = a.getAttribute("value") + '!' + b.getAttribute("value") +'!1!0'

            var x = document.getElementsByClassName("btn-tool")
            var input = document.createElement('li')
            input.setAttribute("id", "bibbtn")
            input.setAttribute("class", "btn-quote")
            //input.setAttribute("type", "button")
            input.setAttribute("title", "Bibtex")
            //input.setAttribute("onclick", "func(this)") href=\"javascript:void(0)\" onclick=\"getBib()\
            input.innerHTML = "<a><i></i>Bibtex</a>"
            x[0].children[0].append(input)




            $("#bibbtn").click(function(){
                $.post("https://kns.cnki.net/kns8/manage/APIGetExport",
                {
                  filename:fileid,
                  displaymode:"NoteExpress"
                },
                function(data){
                    console.log(data);
                    var bibtext = ""
                    var ss = data.data[0].value[0]
                    var ssl = ss.split("<br>")
                    for (var i=0; i<ssl.length-1; i++){
                        var k = ssl[i].toLocaleLowerCase().split(" ").join("").split(":")
                        var item = k[0]
                        var detail = k[1]
                        var useitems = ["title", "author","date","srcdatabase","typeofwork","year","publisher","pages","journal","volume","issue"]
                        console.log(item.slice(1,-1))
                        if (item == "{referencetype}"){
                            if (detail == "journalarticle"){
                                bibtext = "@article{cite_label,\n"
                            }
                            else if(detail == "conferenceproceedings"){
                                bibtext = "@inproceedings{cite_label,\n"
                            }
                            else if(detail == "patent"){
                                bibtext = "@patent{cite_label,\n"
                            }
                            else if(detail == "thesis"){
                                bibtext = "@thesis{cite_label,\n"
                                bibtext = bibtext + "address={},\n"
                            }
                        }
                        else if(useitems.includes(item.slice(1,-1)))
                        {
                            bibtext = bibtext + "   " + item.substr(1, item.length-2) + "={" + detail + "},\n"
                        }
                    }
                    bibtext += "}"
                    console.log(bibtext)
                    const copad = document.createElement('textarea')
                    copad.value = bibtext
                    document.body.appendChild(copad)
                    copad.select()
                    document.execCommand('Copy')
                    document.body.removeChild(copad)
                });
            })



        };



    })
})();