
public class Hexagon  {
	float[] center;
	PShape hexShape;
	IntDict shots;
	boolean selected = false;
	int maxVal = 30; // brightness

	public Hexagon (PShape hexShape, float[] center) {
		this.hexShape = hexShape;
		this.center = center;
		this.shots = new IntDict();
		this.shots.set("", 0);
	}

	void display() {
		// Calc shot accuracy
		float val = max(shots.valueArray())*255/this.maxVal;
		fill(val);
		pushMatrix();
		translate(this.center[0], this.center[1]);
		// if (this.selected) {
		// 	fill(0, 255, 0);
		// 	scale(2.0);
		// }
		shape(this.hexShape);
		popMatrix();
	}

	void addShot(String playerName) {
		int allNum = 0;
		if (this.shots.hasKey(playerName)) {
			allNum = this.shots.get(playerName) + 1;
		}
		this.shots.set(playerName, allNum);
	}

	// void set_selected(boolean b)  {
	// 	this.selected = b;
	// }

	void set_maxVal(int maxVal) {
		this.maxVal = maxVal;
	}

	void resetData() {
		this.shots = new IntDict();
		this.shots.set("", 0);
	}

}

PShape createHex(float r) {
	PShape hexShape = createShape();
	hexShape.beginShape();
	float h = r*sqrt(3)/2;
	// hexShape.fill(100);
	hexShape.vertex(0, -r);
	hexShape.vertex(h, -r/2);
	hexShape.vertex(h,  r/2);
	hexShape.vertex(0, r);
	hexShape.vertex(-h,  r/2);
	hexShape.vertex(-h, -r/2);
	hexShape.endShape(CLOSE);
	hexShape.disableStyle();
	return hexShape;
}

