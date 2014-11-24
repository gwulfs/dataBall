ArrayList<Shot> shots;
PShape court;
HexGrid grid;
int[] gridSize = {25, 25};
float radius;
int size_scale = 2;

void setup() {
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


void draw() {
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

ArrayList<File> getDataFileList(String folderName) {
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

boolean isCountRecordsCorrect(ArrayList<File> dataFiles) {
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

ArrayList<Shot> getData(String file)
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
     int x = int(cur[15])+250;
     int y = int(cur[16])+40;
     boolean made = false;
     if (int(cur[10]) != 0) {
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

	void draw() {
		if (this.made) {
			fill(0, 255, 100);
		} else {
			fill(255, 0, 100);
		}
		ellipse(this.x, this.y, this.r, this.r); 
	}

}
