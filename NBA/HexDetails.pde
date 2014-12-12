
public class HexDetails  {
	Hexagon currentHex = null;
	// Canvas canvas;
	PShape  hexShape;


	public HexDetails (float r) {
		this.hexShape = createHex(2*r);
	}


	void set_newHex(Hexagon newHex) {
		this.currentHex = newHex;
	}

	void display() {
		if (currentHex != null) {
			pushMatrix();
			translate(currentHex.center[0], currentHex.center[1]);
			fill(0, 0, 255);
			shape(this.hexShape);
			popMatrix();
		}
	}
}