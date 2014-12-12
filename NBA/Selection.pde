public class Selection {
    Canvas c;
    CheckBox[] quartersBtn;
    MadeButton shotMadeBtn;
    MultiSlider clockSlider;

    public Selection (Canvas canvas, Controller controller) {
        this.c = canvas;
        quartersBtn = new CheckBox[4];
        for ( int i = 0; i < 4; ++i ) {
            quartersBtn[i] = new CheckBox( str(i+1), c.x + 20 + i*40, c.y + 90, 10, 10 );
            Interactive.on( quartersBtn[i], "checkboxChenged",  this, "quarterChanged" );
        }

        String labels[] = {"all", "made", "not made"};
        shotMadeBtn = new MadeButton(c.x + 20, c.y + 30, 10, 10, labels);
        Interactive.on( shotMadeBtn, "labelChanged",  this, "madeChanged" );

        clockSlider = new MultiSlider( c.x + 20, c.y+140, c.w-40, 10 );
        Interactive.on( clockSlider, "valueChanged",  this, "clockChanged" );
        Interactive.on( clockSlider, "applayVal",  this, "applay" );
    }

    void display() {
        fill(0, 102, 153);
        textAlign( LEFT );
        text( "SHOTS", c.x + 20, c.y + 20 );
        text( "QUARTERS", c.x + 20, c.y + 80 );
        text( "SHOT CLOCK", c.x + 20, c.y + 130 );
        for (CheckBox b : quartersBtn) {
            b.draw();
        }
    }

    void applay() {
        controller.applaySelection();
    }

    void madeChanged(String label) {
        controller.madeLabel = label;
        controller.applaySelection();
    }

    void clockChanged(float minVal, float maxVal) {
        controller.shot_clock[0] = minVal*24;
        controller.shot_clock[1] = maxVal*24;
        // controller.applaySelection();
    }

    void quarterChanged(String label, boolean checked) {
        int i = int(label);
        controller.quarters[i-1] = checked;
        controller.applaySelection();
    }

}
