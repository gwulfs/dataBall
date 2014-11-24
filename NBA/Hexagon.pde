
public class Hexagon  {
	float[] center;
	PShape hexShape;
	IntDict allShots;
	IntDict madeShots;

	public Hexagon (PShape hexShape, float[] center) {
		this.hexShape = hexShape;
		this.center = center;
		this.allShots = new IntDict();
		this.allShots.set("", 0);
		this.madeShots = new IntDict();
		this.madeShots.set("", 0);
	}

	void display() {
		float val = 20.0*max(allShots.valueArray());
		fill(val);
		pushMatrix();
		translate(this.center[0], this.center[1]);
		shape(this.hexShape);
		popMatrix();
	}

	void addShot(String playerName, boolean made) {
		int allNum = 0;
		if (this.allShots.hasKey(playerName)) {
			allNum = this.allShots.get(playerName);
		}
		this.allShots.set(playerName, ++allNum);
		if (made) {
			int madeNum = 0;
			if (this.madeShots.hasKey(playerName)) {
				madeNum = this.madeShots.get(playerName);
			}
			madeNum = this.madeShots.get(playerName);
			this.madeShots.set(playerName, ++madeNum);
		}
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

