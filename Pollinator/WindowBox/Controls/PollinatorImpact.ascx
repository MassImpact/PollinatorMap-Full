<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PollinatorImpact.ascx.cs" Inherits="WindowBox_Controls_PollinatorImpact" %>

<style type="text/css">
    .garden div {
        /*border: solid 1px red;*/
        display: block;
        position: absolute;
    }

    .garden div:hover {
        background: rgba(100, 100, 100, 0.5);
        -moz-border-radius: 50%; 
        -webkit-border-radius: 50%; 
        border-radius: 50%;
    }

    .garden ul li.pot img
    {
        z-index: -1;
    }
</style>

<!--Drop Zone-->
<div class="garden" style="height: 450px;width:666px;margin:auto;background: url(<%= ResolveUrl("../Images/plant_window.png")%>) no-repeat 50%;background-size: 100% 100%;">
  
            <div id="Li1" class="pot" style="width: 130px;height:130px;margin-top:190px;margin-left:55px;" frame-radius='85' frame-left='25' frame-top='25'></div>
    
            <div id="Li2" class="pot" style="width: 90px;height:90px;top:220px;left:220px;" frame-radius='50' frame-left='25' frame-top='5'></div>
 
            <div id="Li3" class="pot" style="width: 90px;height:90px;top:190px;left:340px;" frame-radius='50' frame-left='20' frame-top='25'></div>

            <div id="Li4" class="pot" style="width: 90px;height: 90px;top:210px;left:485px;" frame-radius='60' frame-left='15' frame-top='13'></div>
     
<%--        <li id="pot1" class="pot" style="width: 130px;height:130px;top:-140px;margin-left:15px;" frame-radius='85' frame-left='25' frame-top='225'></li>
        <li id="pot2" class="pot" style="width: 80px;height: 80px;top:-155px;left:15px;" frame-radius='60' frame-left='10' frame-top='245'></li>
        <li id="pot3" class="pot" style="width: 90px;height: 90px;top:-155px;left:25px;" frame-radius='60' frame-left='20' frame-top='230'></li>
        <li id="pot4" class="pot" style="width: 90px;height: 90px;top:-155px;left:45px;" frame-radius='60' frame-left='20' frame-top='230'></li>--%>
    </ul>
</div>