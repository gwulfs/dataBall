public class Canvas {
    float x;
    float y;
    float w;
    float h;
    ArrayList<Canvas> selections;
    
    Canvas(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.selections = new ArrayList<Canvas>();
    } 
    
    void update(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
    void drawRect(float val)
    {
        stroke(0);
        fill(val);
        strokeWeight(1);
        rect(x, y, w, h); 
    }
    
    void drawRect(float v1, float v2, float v3)
    {
        stroke(0);
        fill(v1, v2, v3);
        strokeWeight(1);
        rect(x, y, w, h); 
    }
    
    boolean mouseOver()
    {
        return covers(mouseX, mouseY); 
    }
    
    boolean covers(float px, float py)
    {
        return (px > x && px < x + w && py > y && py < y + h);
    }
}
