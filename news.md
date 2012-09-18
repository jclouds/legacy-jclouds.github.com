---
layout: jclouds
title: jclouds Home
---

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
<script type="text/javascript" src="http://blog.jclouds.org/api/read/json"></script>
<script type="text/javascript">
	$(document).ready(function() {
		console.log(tumblr_api_read);
		var posts=tumblr_api_read['posts'];
		for(i in posts) {
			var post = posts[i];
			$("#column2").append($("<div>")
					.append($("<h1>").addClass("news").text(post['regular-title']))
					.append($("<h2>").addClass("news").text(post['date']))
			        .append($("<span>").addClass("news").html(post['regular-body'])));
		}
	});
</script>
