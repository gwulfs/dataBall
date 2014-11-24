import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class NBA extends PApplet {

ArrayList<Shot> shots;
PShape court;
HexGrid grid;
int[] gridSize = {25, 25};
float radius;
int size_scale = 2;

public void setup() {
	size(500*size_scale, 350*size_scale, P2D);
	// size(1000, 800);
	radius = width/((gridSize[0] -1 )*sqrt(3));
	grid = new HexGrid(gridSize, radius);
	// ArrayList<File> files = getDataFileList("data");
	// println(isCountRecordsCorrect(files));
	shots = getData("durant.csv");
	court = loadShape("img/NBA_ready.svg");
	PShape hexShape = createHex(width/10);

	// hexagon = new Hexagon(hexShape, center);
	grid.hexShape.fill(200);
}


public void draw() {
	background(255);
	// pushMatrix();
	// translate(100, 100);
	// scale(.5);
	grid.display();
	// popMatrix();
	shape(court, 0, 0, 1000, 1000*28/50);
	for (Shot s : shots) {
		s.draw();
	}
	// hexagon.display();
}

public ArrayList<File> getDataFileList(String folderName) {
	File folder = new File(folderName);
	File[] listOfFiles = folder.listFiles();
	ArrayList<File> dataFiles = new ArrayList<File>();
	String pattern = "nba_savant(\\w*).csv";
	for (int i = 0; i < listOfFiles.length; i++) {
		if (listOfFiles[i].isFile()) {
			if (listOfFiles[i].getName().matches(pattern)) {
				dataFiles.add(listOfFiles[i]);
			}
		} else if (listOfFiles[i].isDirectory()) {
			println("Directory " + listOfFiles[i].getName());
		}
	}
	return dataFiles;
}

public boolean isCountRecordsCorrect(ArrayList<File> dataFiles) {
	int sum = 0;
	for (File f : dataFiles) {
		String [] filedata = loadStrings(f);
		println("filedata.length: " + filedata.length);
		sum += filedata.length -1;
	}
	// check hardcoded record num with expected value
	if (sum == 204126) {
		return true;
	} else {
		return false;
	}
}

public ArrayList<Shot> getData(String file)
{
  ArrayList<Shot> d = new ArrayList<Shot>();
  String [] filedata = loadStrings(file);
  int len = filedata.length - 1;
  // Hexagon currentHex;
  String [] cur;
   for (int i = 1; i <= len; i++) {
     cur = splitTokens(filedata[i], ",");
     // print("cur[15]: "+cur[15]);
     // print("   ");
     // println("cur[16]: "+cur[16]);
     int x = PApplet.parseInt(cur[15])+250;
     int y = PApplet.parseInt(cur[16])+40;
     boolean made = false;
     if (PApplet.parseInt(cur[10]) != 0) {
     	made = true;
     }
     d.add(new Shot(x, y, made));
     // currentHex = grid.get_hexagon_fromXY(x*size_scale, y*size_scale);
     grid.addShot(x*size_scale, y*size_scale, cur[0], made);
   }
   return d;
}


public class Shot  {
	int x;
	int y;
	int r = 4;
	boolean made = false;

	public Shot (int x, int y, boolean made) {
		this.x = x*2;
		this.y = y*2;
		this.made = made;
	}

	public void draw() {
		if (this.made) {
			fill(0, 255, 100);
		} else {
			fill(255, 0, 100);
		}
		ellipse(this.x, this.y, this.r, this.r); 
	}

}
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

	public void createGrid() {
		for (int iy = 0; iy < this.size[1]; ++iy) {
			for (int ix = 0; ix < this.size[0]; ++ix) {
				int[] c = {ix, iy};
				float[] center = this.get_hexCenter(c);
				grid[ix][iy] = new Hexagon(this.hexShape, center);
			}
		}
	}

	public void display() {
		float t = 1;
		for (Hexagon[] hexCol : this.grid) {
			for (Hexagon h : hexCol) {
				fill(t);
				t += 1;
				h.display();
			}
		}
	}

	public boolean addShot(int x, int y, String playerName, boolean made) {
		try {
			Hexagon currHex = this.get_hexagon_fromXY(x, y);
			currHex.addShot(playerName, made);
			return true;
		} catch (ArrayIndexOutOfBoundsException e) {
			println("out of bound");
			return false;
		}
	}

	public Hexagon get_hexagon_fromXY(float x, float y) {
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

	public Hexagon get_hexagon_fromIndex(int[] index) {
		int ix = index[0] + index[1]/2;
		int iy = index[1];
		return grid[ix][iy];
	}

	public int[] get_hexIndex(int[] index) {
		index[0] = index[0] - index[1]/2;
		return index;
	}

	public float[] get_hexCenter(int[] coords){
		int hexCords[] = this.get_hexIndex(coords);
		float h = (this.r*sqrt(3)/2);
		float[] vec = {h*(2*hexCords[0] + hexCords[1]), 1.5f*this.r*hexCords[1]};
		return vec;
	}

}

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

	public void display() {
		float val = 20.0f*max(allShots.valueArray());
		fill(val);
		pushMatrix();
		translate(this.center[0], this.center[1]);
		shape(this.hexShape);
		popMatrix();
	}

	public void addShot(String playerName, boolean made) {
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

public PShape createHex(float r) {
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

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "NBA" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
