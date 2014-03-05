function calibrateSizes() {
  $$('.fullheight').each(function(item) {
    var h=item.getHeight();
    item.style.height=1;
    item.store('h',item.getHeight()-1);
    item.style.height=h-item.getHeight()-1;
  });
  $$('.fullwidth').each(function(item) {
    var w=item.getWidth();
    item.style.width=1;
    item.store('w',item.getWidth()-1);	 
    item.style.width=w-item.getWidth()-1;	  
  });
  correctSize();
  Event.observe(window, 'resize', correctSize);
}
function correctSize() {
  $$('.fullheight').each(function(item) {
    item.style.height=window.innerHeight -item.viewportOffset().top-item.retrieve('h');
  });
  $$('.fullwidth').each(function(item) {
    item.style.width=window.innerWidth -item.viewportOffset().width-item.retrieve('w');
  });
}

Event.observe(window, 'load', calibrateSizes);
