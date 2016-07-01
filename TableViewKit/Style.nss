
/* VARIABLES */

@primaryFontColor: #333333;
@mono00: #FFFFFF;
@mono03: #CCCCCC;
@secondaryBrand: #FFCC00;

@borderWidthS: 0.5;
@borderWidthM: 0.8;
@borderWidthL: 1;

@baseCellCornerRadius: 5,0;

@cornerHeader: 4,0;

/* CONTROLS */

Label {
    font-size: 15;
}

Switch {
    on-tint-color: @secondaryBrand;
}

/* CELLS */

BaseCell {
    background-color: @mono00;
    background-color-selected: @secondaryBrand;
    border-color: @mono03;
    border-width: @borderWidthM;
    borders: 1 1 1 1;
}

BottomCell {
    borders: 1 1 1 1;
    corners: 0 0 1 1;
    corner-radius: @baseCellCornerRadius;
}

TopCell {
    borders: 1 1 0 1;
}

MiddleCell {
    borders: 1 1 0 1;
}

/* HEADERS */

BaseHeader {
    background-color: @secondaryBrand;
    corners: 1 1 0 0;
    corner-radius: @baseCellCornerRadius;
    borders: 1 1 0 1;
    border-color: @mono03;
}