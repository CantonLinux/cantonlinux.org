---
layout: page
current: schedule
title: Schedule
---
# Event Schedule {{site.orgname}}

<table>
{% for event in site.data.schedule %}
    <tr>
        <td>{{ event.date }}</td>
        <td>{{ event.title }}</td>
        <td>{{ event.presenter }}</td>
    </tr>
{% endfor %}
</table>
