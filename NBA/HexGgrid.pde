public class HexGrid  {
	int[] size;
	float r;
	Hexagon[][] grid;
	PShape  hexShape;

	public HexGrid (int[] size, float r) {
		this.size = size;
		this.r = r;
		this.grid = new Hexagon[size[0]][size[1]];
		this.hexShape = createHex(this.r);
		this.createGrid();
	}

	void createGrid() {
		for (int iy = 0; iy < this.size[1]; ++iy) {
			for (int ix = 0; ix < this.size[0]; ++ix) {
				int[] c = {ix, iy};
				float[] center = this.get_hexCenter(c);
				grid[ix][iy] = new Hexagon(this.hexShape, center);
			}
		}
	}

	void display() {
		float t = 1;
		for (Hexagon[] hexCol : this.grid) {
			for (Hexagon h : hexCol) {
				fill(t);
				t += 1;
				h.display();
			}
		}
	}

	boolean addShot(int x, int y, String playerName, boolean made) {
		try {
			Hexagon currHex = this.get_hexagon_fromXY(x, y);
			currHex.addShot(playerName, made);
			return true;
		} catch (ArrayIndexOutOfBoundsException e) {
			println("out of bound");
			return false;
		}
	}

	Hexagon get_hexagon_fromXY(float x, float y) {
		int q = round((sqrt(3)*x/3 - y/3)/this.r);
		int p = round((2*y)/(3*this.r));
		// Hexagon curhex;
		// try {
		return this.get_hexagon_fromIndex(new int[] {q, p});
		// } catch (ArrayIndexOutOfBoundsException e) {
		// 	print("p: "+p);
		// 	print(" q: "+q);
		// 	print(" x: "+x);
		// 	print(" y: "+y);
		// 	println(" this.r: "+this.r);
		// 	return null;
		// }
	}

	Hexagon get_hexagon_fromIndex(int[] index) {
		int ix = index[0] + index[1]/2;
		int iy = index[1];
		return grid[ix][iy];
	}

	int[] get_hexIndex(int[] index) {
		index[0] = index[0] - index[1]/2;
		return index;
	}

	float[] get_hexCenter(int[] coords){
		int hexCords[] = this.get_hexIndex(coords);
		float h = (this.r*sqrt(3)/2);
		float[] vec = {h*(2*hexCords[0] + hexCords[1]), 1.5*this.r*hexCords[1]};
		return vec;
	}

}