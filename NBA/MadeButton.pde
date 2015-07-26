public class MadeButton {
    float x, y, width, height;
    boolean on = true;
    String[] labels;
    float padx = 6;
    int currentLabel = 0;
    
    MadeButton(float xx, float yy, float w, float h, String[] labels) {
        x = xx; y = yy; width = w; height = h;
        this.labels = labels;
        Interactive.add(this);
    }
    
    void mousePressed() {
        on = !on;
    }
    void mouseReleased() {
        on = !on;
        currentLabel += 1;
        currentLabel = currentLabel % 3;
        Interactive.send(this, "labelChanged", labels[currentLabel]);
    }

    void draw() {
        if(on) fill(200);
        else fill(100);
        noStroke();
        rect(x, y, width, height);
        textAlign(LEFT);
        fill(100);
        text(labels[currentLabel], x+width+padx, y+height);
        stroke(0);
    }

    boolean isInside(float mx, float my) {
        return Interactive.insideRect(x,y,width+padx+textWidth(labels[currentLabel]), height, mx, my);
    }
}