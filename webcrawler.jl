# importing the required packages
using HTTP, Gumbo

# defining a constant variable for the page url
const PAGE_URL = "https://en.wikipedia.org/wiki/Julia_(programming_language)"

# defining a constant String array 
const LINK_URL = String[]


"""
        get_page(url)
    Returns the body of a webpage given its url. 

    #Arguments 
    url - The url of the webpage
"""
function get_page(url)
    response = HTTP.get(url)
    if response.status == 200 && parse(Int, Dict(response.headers)["Content-Length"]) > 0
        String(response.body)
    else 
        ""
    end 
end 

content = get_page(PAGE_URL); 

"""
        extract_links(elem)
    extract the links out of a webpage. 

    #Arguments 

    elem - Gumbo element 
"""
function extract_links(elem)
    if isa(elem,HTMLElement) && tag(elem) == :a && in("href",collect(keys(attrs(elem))))
        url = getattr(elem, "href")
        startswith(url,"/wiki/") && ! occursin(":",url) && push!(LINK_URL,url)
    end 

    for child in children(elem)
        extract_links(child)
    end 
end 

if !isempty(content) 
    dom = Gumbo.parsehtml(content) 
    extract_links(dom.root) 
end


display(unique(LINK_URL))