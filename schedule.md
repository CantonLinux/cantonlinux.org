---
layout: page
current: schedule
title: Schedule
---
# Event Schedule {{site.orgname}}

<table>
    <tr>
        <th valign="top">Date</th>
        <th valign="top">Title</th>
        <th valign="top">Presenter</th>
    </tr>
{% for event in site.data.schedule %}
    <tr>
        <td valign="top">{{ event.date | replace: ' ', '&nbsp;' }}</td>
        <td valign="top">{{ event.title }}</td>
        <td valign="top">{{ event.presenter }}</td>
    </tr>
{% endfor %}
</table>
