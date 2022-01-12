function scrollIntoViewPort(group_name){
    var xpath = "//li[@title = '" + group_name + "']";
    var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    var bounding = element.getBoundingClientRect();
    var isInViewport = (
        bounding.top >= 0 &&
        bounding.left >= 0 &&
        bounding.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        bounding.right <= (window.innerWidth || document.documentElement.clientWidth)
    );

    if(!isInViewport)
        element.scrollIntoView();
}