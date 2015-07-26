public class Controller {
    PostgreSQL pgsql;
    HexGrid grid;
    String madeLabel = "all";
    boolean[] quarters = {false, false, false, false, false};
    float[] shot_clock = {.0, 24.0};

    public Controller(PostgreSQL pgsql, HexGrid grid) {
        this.pgsql = pgsql;
        this.grid = grid;
    }

    void applaySelection() {
        this.grid.resetHexData();
        if(this.pgsql.connect()) {
            String query = "SELECT x, y, name  FROM shots";
            query += getConditionQuerry();
            println("query: "+query);
            this.pgsql.query(query);
            while(this.pgsql.next()) {
                int x = this.pgsql.getInt("x") + 250;
                int y = this.pgsql.getInt("y") + 40;
                String name = this.pgsql.getString("name");
                this.grid.addShot(x, y, name);
            }
        }
    }

    String getConditionQuerry() {
        String startQuerry = " WHERE ";
        String quarterQuerry = "";
        String conditionQuerry = "(shot_clock>" + this.shot_clock[0] + " AND shot_clock<" + this.shot_clock[1] + ")";
        for(int i = 0; i < 5; ++i) {
            if(quarters[i]) {
                if(quarterQuerry != "") {
                    quarterQuerry += " OR ";
                }
                quarterQuerry += " period=" + str(i+1);
            }
        }
        if(quarterQuerry != "") {
            conditionQuerry += " AND (" + quarterQuerry + ")";
        }
        if(madeLabel != "all") {
            String madeQuerry = "";
            if(madeLabel == "not made") {
                madeQuerry = "shot_made_flag=false";
                
            } else {
                madeQuerry = "shot_made_flag=true";
            }
            conditionQuerry += " AND " + madeQuerry;
        }
        return startQuerry + conditionQuerry;
    }

}