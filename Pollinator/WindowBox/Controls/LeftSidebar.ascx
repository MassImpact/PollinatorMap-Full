<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftSidebar.ascx.cs" Inherits="WindowBox_LeftSidebar" %>

<h3 style="color:white">Your Window Box</h3>

<p>
    <span>Account Info</span>
    <a href="#" style="float:right">edit</a>
</p>

<p style="color:white;line-height:30px">
FULLNAME  <br />
CITYSTATE <br/>
EMAIL <br/>
</p>

<p>
    <h3>Your Plants</h3>
    <a href="#" style="float:right">edit</a>
</p>

<p>
    <h3>Impact</h3>
</p>

<img src='<%= ResolveUrl("../Images/pollinator_impact.png") %>'/>


<p>
    <h1>SHARE</h1>
</p>

<input type="button" value="Embed" />