<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PollinatorWindowBox.aspx.cs" Inherits="WindowBox_PollinatorWindowBox" %>

<%@ Register Src="~/WindowBox/Controls/PlantCarousel.ascx" TagPrefix="uc1" TagName="PlantCarousel" %>
<%@ Register Src="~/WindowBox/Controls/PollinatorImpact.ascx" TagPrefix="uc1" TagName="PollinatorImpact" %>
<%@ Register Src="~/WindowBox/Controls/LeftSidebar.ascx" TagPrefix="uc1" TagName="LeftSidebar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="WindowBox.css" rel="stylesheet" />
    
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.3/themes/smoothness/jquery-ui.css" />
</head>
<body>
    <form id="form1" runat="server">
    <script type="text/javascript" src="PlantDragable.js"></script>
        
    <style type="text/css">
        .col_left {
            position:absolute;
            left:0;top:0;
            bottom:0;
            height:auto;
            width:250px;
            display: block;

            float:left;
            background-color: orange;
            padding:10px;
        }

        .col_main {
            display: block;
            position: absolute;
            height:auto;
            bottom:0;
            top:0;
            left:280px;
            right:0;
        }
    </style>
    
    <!--
        Two Columns, Full Browser Height:
        http://www.usablecreative.com/under-the-hood/two-columns-full-browser-height
        -->
    <div class="col_left">
        <uc1:LeftSidebar runat="server" ID="LeftSidebar" />
    </div>

    <div class="col_main">
        <uc1:PollinatorImpact runat="server" ID="PollinatorImpact" />
        
        <br/><br/>
        <uc1:PlantCarousel runat="server" ID="PlantCarousel" />
    </div>
        
    </form>
</body>
</html>
