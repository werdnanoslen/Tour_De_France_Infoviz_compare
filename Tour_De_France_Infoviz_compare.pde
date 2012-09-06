import controlP5.*;

color bg = #f4f4f4;
color black = #332626;
color grey = #cccccc;
color yellow = #fabb00;
color darkYellow = #E88F0C;
color red = #ff0000;

int axesOffsetX;
int axesOffsetY;
int axesHeight;
int axesWidth;

int numCases;

int[] years;
String[] countries;
Map<String, Integer> winCounts;
Map<String, String> winYears;

ControlP5 controlP5;
String details;

void setup()
{
    size(900, 630);
    background(bg);
    
    axesOffsetX = 100;
    axesOffsetY = 150;
    axesHeight = 400;
    axesWidth = width-2*axesOffsetX;
    
    numCases = 5;
    
    String[] data = loadStrings("Tour_De_France_Data.csv");
    years = new int[data.length-1];
    countries = new String[data.length-1];
    winCounts = new HashMap<String, Integer>();
    winYears = new HashMap<String, String>();
    
    for (int i=0; i<data.length-1; ++i)
    {
        String currentRow = data[i+1]; //+1 to skip title row
        String[] columns = split(currentRow, ",");
        years[i] = int(columns[0]);
        countries[i] = columns[3];
    }
    
    for (int i=0; i<countries.length; ++i)
    {
        winCounts.put(countries[i], 0);
        winYears.put(countries[i], "");
    }
    
    String comma = "";
    for (int i=0; i<winCounts.size(); ++i)
    {
        winCounts.put(countries[i], 1+winCounts.get(countries[i])); //why doesn't ++ work here?
        comma = ("" == winYears.get(countries[i])) ? "" : ", ";
        winYears.put(countries[i], winYears.get(countries[i])+comma+years[i]);
    }
}

void controlEvent(ControlEvent theEvent)
{
}

void detailsOnDemand()
{
}

void showDetails(int i)
{
}

    
void plot()
{    
}

void drawAxes()
{
    fill(black);
    stroke(black);
    
    //years
    line(axesOffsetX, axesOffsetY+axesHeight, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
    
    line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight);

    stroke(darkYellow);
    fill(darkYellow);
}

void drawLabels()
{
    fill(bg);
    stroke(black);
    rect(axesOffsetX-10, axesOffsetY-130, 135, 80, 15, 15, 15, 15);
    //reset, arrggh why can't colors be set per function? T_T
    fill(black);
    
    textSize(12);
    text("CONTROL PANEL", axesOffsetX-2, axesOffsetY-110);
    
    textSize(40);
    textAlign(RIGHT);
    text("Tour De France", axesOffsetX+axesWidth, axesOffsetY-100);
    
    textSize(20);
    text("Countries by range of wins (1903-2010)", axesOffsetX+axesWidth, axesOffsetY-70);
    
    textSize(18);
    textAlign(CENTER);
    text("Number of wins", axesOffsetX+axesWidth/2, axesOffsetY+axesHeight+45);
    
    //reset
    textSize(11);
    textAlign(LEFT);
    

    fill(black);
    textSize(18);
    textAlign(CENTER);
    translate(axesOffsetX/2, axesOffsetY+axesHeight/2);
    rotate(-PI/2);
    text("Country", 0, 0);
    //reset
    rotate(PI/2);
    translate(-(axesOffsetX/2), -(axesOffsetY+axesHeight/2));
    textAlign(LEFT);
    textSize(11);
}
                
void draw()
{
    smooth(); //nothing's changing much, so might as well...
    background(bg); //clears screen
    drawAxes();
    plot();
    drawLabels();
    detailsOnDemand();
}

