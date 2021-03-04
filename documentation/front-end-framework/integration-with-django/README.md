# 2.3.1. Integration with Django

We designed a base.html, then using DTL codeblocks, extended this template to other webpages, adding a uniformity of design to each page. The base.html also includes a codeblock which loads the static files for use. Django development usually includes the creation of a /static/ directory, where the developer would keep their “static” files, that is, files that once created don’t tend to change, such as .css, .js, or image files. 
The base template includes areas to input content from other pages, called content blocks. Then in other HTML templates, the developer need only specify what on the page is content, and this will be inserted in the correct area on the base.html. 
This method aids reproducibility and uniformity.
```
/data/htf.html

{% extends "data/base.html" %}

{% block content %}

   <main role="main" class="container">
       <h1 class="mt-4">{{ title }}</h1>
       <div class="container">
           <form action="{% url 'htf_results' %}" method="get">
               <input name="q" type="text" placeholder="Search HTFs...">
           </form>
       </div>

       {% for htf in page_obj %}
           <div class="card mb-4">
               <div class="card-body" style="margin-left:15px">
                   <h5 style="font-weight:600">Name: <a href="/htf/{{ htf.gene_name }}/">{{ htf.gene_name }}</a></h5>
                   <p class="card-text text-muted h6">Ensemble ID: {{ htf.ensemble_id }} </p>
                   <p class="card-text">Protein name: {{htf.prot_name}}</p>
               </div>
           </div>
       {% endfor %}

       <div class="pagination">
           <span class="step-links">
               {% if page_obj.has_previous %}
                   <a href="?page=1">&laquo; first</a>
                   <a href="?page={{ page_obj.previous_page_number }}">previous</a>
               {% endif %}

               <span class="current">
                   Page {{ page_obj.number }} of {{ page_obj.paginator.num_pages }}.
               </span>

               {% if page_obj.has_next %}
                   <a href="?page={{ page_obj.next_page_number }}">next</a>
                   <a href="?page={{ page_obj.paginator.num_pages }}">last &raquo;</a>
               {% endif %}
           </span>
       </div>
   </main>
{% endblock content %}
```

Here the `{% extends "data/base.html" %}` and `{% block content %}` allow the developer to write page-specific HTML and insert it into the base template, 
avoiding rewriting all the HTML for the base template for each other page template. 
  
One point to note is that the code blocks, once opened, must be closed, i.e. `{% block %}` requires `{% endblock %}`, `{% if %}` requires `{% endif %}`.
