﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Flower.aspx.cs" Inherits="WindowBox_Admin_Flower" %>


<%@ Register Src="~/WindowBox/Admin/Controls/LeftSidebar.ascx" TagPrefix="uc" TagName="LeftSidebar" %>
<%@ Register Src="~/WindowBox/Admin/Controls/TopSidebar.ascx" TagPrefix="uc" TagName="TopSidebar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>


    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.3/themes/smoothness/jquery-ui.css" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="col_left">
            <uc:LeftSidebar runat="server" ID="LeftSidebar" />
        </div>

        <div class="col_main">
            <uc:TopSidebar runat="server" Name="Flowers" ID="TopSidebar" />
            <div class="divtable">
                <table class="table table-hover" cellspacing="0" rules="all" border="1" id="MainContent_UserAccounts" style="border-collapse: collapse;">
                    <tbody>
                        <tr >
                            <th scope="col">Flower ID #</th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Status
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Common Name
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Eco Region
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                # Zip Codes
                            </th>
                            <th scope="col" style="white-space: nowrap;">
                                <div class="vertical-line"></div>
                                # Window Boxes 
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Image
                            </th>
                            <th scope="col">
                                <div class="vertical-line">Delete</div>
                            </th>
                        </tr>
                        <tr>
                            <td style="width: 16%;">
                                <span class="wrap">00001</span>
                            </td>
                            <td style="width: 19%;">
                                <span class="wrap">Published</span>
                            </td>
                            <td style="width: 19%;">
                                <span class="wrap">Flower </span>
                            </td>
                            <td style="width: 10%;">001
                            </td>
                            <td style="width: 8%;">50
                            </td>
                            <td style="width: 10%;">100
                            </td>
                            <td style="width: 20%;">IMAGE
                            </td>
                            <td style="width: 8%;">
                                <a class="delete-link">Delete</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Published</span>
                            </td>
                            <td>
                                <span class="wrap">Flower </span>
                            </td>
                            <td>001
                            </td>
                            <td>50
                            </td>
                            <td>100
                            </td>
                            <td>IMAGE
                            </td>
                            <td>
                                <a class="delete-link">Delete</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Published</span>
                            </td>
                            <td>
                                <span class="wrap">Flower </span>
                            </td>
                            <td>001
                            </td>
                            <td>50
                            </td>
                            <td>100
                            </td>
                            <td>IMAGE
                            </td>
                            <td>
                                <a class="delete-link">Delete</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Published</span>
                            </td>
                            <td>
                                <span class="wrap">Flower </span>
                            </td>
                            <td>001
                            </td>
                            <td>50
                            </td>
                            <td>100
                            </td>
                            <td>IMAGE
                            </td>
                            <td>
                                <a class="delete-link">Delete</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Published</span>
                            </td>
                            <td>
                                <span class="wrap">Flower </span>
                            </td>
                            <td>001
                            </td>
                            <td>50
                            </td>
                            <td>100
                            </td>
                            <td>IMAGE
                            </td>
                            <td>
                                <a class="delete-link">Delete</a>
                            </td>
                        </tr>


                        <tr class="pager">
                            <td colspan="8">
                                <div style="float: left">
                                    <label>
                                        <select>
                                            <option value="10" selected>10</option>
                                            <option value="25">25</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                        Per Page</label>
                                </div>
                                <div style="float: right">
                                    <ul class="pagination">
                                        <li class="paginate_button previous" aria-controls="datatablesUserList" tabindex="0"
                                            id="datatablesUserList_previous"><a href="#">Previous</a></li>
                                        <li class="paginate_button active" aria-controls="datatablesUserList" tabindex="0"><a href="#">1</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0">
                                            <a href="#">2</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">3</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">4</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">5</a></li>
                                        <li class="paginate_button next disabled" aria-controls="datatablesUserList" tabindex="0" id="datatablesUserList_next"><a href="#">Next</a></li>

                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </form>
</body>
</html>
