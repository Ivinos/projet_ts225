function Dlabel=label(D)
    Dlabel=bwlabel(D);
    Dlabel.*(255/max(max(Dlabel)));
    figure,imshow(uint8(Dlabel.*(255/max(max(Dlabel)))));
    
end