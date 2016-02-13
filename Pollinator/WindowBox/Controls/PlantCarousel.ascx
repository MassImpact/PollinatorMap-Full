<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PlantCarousel.ascx.cs" Inherits="WindowBox_Controls_PlantCarousel" %>

<link rel="stylesheet" type="text/css" href='<%= ResolveUrl("~/css/jquery.bxslider.css") %>' />
<script type="text/javascript" src='<%= ResolveUrl("~/js/jquery.bxslider.min.js") %>'></script>

<script type="text/javascript">
    $(document).ready(function () {
        $('.bxslider').bxSlider({
            slideWidth: 200,
            minSlides: 2,
            maxSlides: 4,
            nextText: 'Next',
            prevText: 'Prev',
            slideMargin: 10
        });
    });
</script>

<style type="text/css">
    /*.bxslider li {
        width: 200px !important;
    }*/
    .bxslider li img {
        width: 200px;
        height: 200px;
    }

    .bx-prev {
        margin-left: -50px;
    }
    .bx-next {
        margin-right: -50px;
    }
</style>

<%--<ul class="dragable-zone">
    <li class='dragable-data' style="border:solid 2px blue">
        <img src='<%= ResolveUrl("../PlantImages/Aronia_arbutifolia.JPG") %>' />
    </li>
</ul>--%>


  <%--  <div class="bx-viewport" style=" overflow: hidden; position: relative; ">

    </div>--%>

        <ul class="bxslider dragable-zone">
            <li id="li1" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Aronia_arbutifolia.JPG") %>' />
            </li>
            <li id="li2" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Asclepias_fascicularis.JPG") %>' />
            </li>
            <li id="li3" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Asclepias_incarnata.JPG") %>' />
            </li>
            <li id="li4" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Asclepias_tuberosa.JPG") %>' />
            </li>
            <li id="li5" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Aster_spp.JPG") %>' />
            </li>
            <li id="li6" class='dragable-data'>
                <img src='<%= ResolveUrl("../PlantImages/Balsamorhiza_sagittata.JPG") %>' />
            </li>
        </ul>