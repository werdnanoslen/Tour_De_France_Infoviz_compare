import controlP5.*;
import java.util.Map;


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
String[] countrySet;
String[][] uniqueCountries;
Map<String, Integer> winCounts;
Map<String, String> winYears;

ControlP5 controlP5;
int minWins;
int maxWins;
int minWinsSelected;
int maxWinsSelected;
DropdownList minWinsList;
DropdownList maxWinsList;

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
    
    minWins = 0;
    maxWins = 0;
    String comma = "";
    for (int i=0; i<winCounts.size(); ++i)
    {
        winCounts.put(countries[i], 1+winCounts.get(countries[i])); //why doesn't ++ work here?
        comma = ("" == winYears.get(countries[i])) ? "" : ", ";
        winYears.put(countries[i], winYears.get(countries[i])+comma+years[i]);
        
        if (minWins > winCounts.get(countries[i])) minWins = winCounts.get(countries[i]);
        if (maxWins < winCounts.get(countries[i])) maxWins = winCounts.get(countries[i]);
    }
    minWinsSelected = minWins;
    maxWinsSelected = maxWins;
    
    uniqueCountries = new String[winCounts.size()][2];
    countrySet = winCounts.keySet().toArray(new String[0]);
    for (int i=0; i<uniqueCountries.length; ++i)
    {
        uniqueCountries[i][0] = countrySet[i];
        uniqueCountries[i][1] = str(winCounts.get(countrySet[i]));
    }
    Arrays.sort(uniqueCountries, new ArrayComparator(1, false));

    controlP5 = new ControlP5(this);
    minWinsList = controlP5.addDropdownList("minWinsSelected",axesOffsetX,axesOffsetY+axesHeight+30,70,50);
        minWinsList.captionLabel().set("Select Min");
        minWinsList.captionLabel().style().marginTop = 1;
        minWinsList.setBarHeight(11);
        for (int i=minWins; i<maxWins; ++i)
        {
            minWinsList.addItem(str(i), i);
        }
    maxWinsList = controlP5.addDropdownList("maxWinsSelected",axesOffsetX+axesWidth-70,axesOffsetY+axesHeight+30,70,50);
        maxWinsList.captionLabel().set("Select Max");
        maxWinsList.captionLabel().style().marginTop = 1;
        maxWinsList.setBarHeight(11);
        for (int i=minWins; i<maxWins; ++i)
        {
            maxWinsList.addItem(str(i), i);
        }
}

class ArrayComparator implements Comparator<Comparable[]> 
{
    private final int columnToSort;
    private final boolean ascending;

    public ArrayComparator(int columnToSort, boolean ascending) 
    {
        this.columnToSort = columnToSort;
        this.ascending = ascending;
    }

    public int compare(Comparable[] c1, Comparable[] c2) 
    {
        int cmp = c1[columnToSort].compareTo(c2[columnToSort]);
        return ascending ? cmp : -cmp;
    }
}

void controlEvent(ControlEvent theEvent)
{
    if(theEvent.isFrom(minWinsList))
    {
        minWinsSelected = (int)minWinsList.value();
    }
    else if(theEvent.isFrom(maxWinsList))
    {
        maxWinsSelected = (int)maxWinsList.value();
    }
    /*else if(theEvent.isFrom(sortAscending))
    {
        Arrays.sort(uniqueCountries, new ArrayComparator(1, true));
    }
    else if(theEvent.isFrom(sortDescending))
    {
        Arrays.sort(uniqueCountries, new ArrayComparator(1, false));
    }*/
}

void detailsOnDemand()
{
}

void showDetails(int i)
{
}
    
void plot()
{
    textAlign(RIGHT, CENTER);
    textSize(18);
    int barOffset = axesHeight/5;
    for (int i=0, j=1; i<uniqueCountries.length-1; ++i)
    {
        if (minWinsSelected <= int(uniqueCountries[i][1]) && int(uniqueCountries[i][1]) <= maxWinsSelected)
        {
            text(uniqueCountries[i][0], axesOffsetX-20, axesOffsetY+30+barOffset*i);
            rect(axesOffsetX, axesOffsetY+50+barOffset*i, map(winCounts.get(uniqueCountries[i][0]), minWins, maxWins, 0, axesWidth), -40);
            ++j;
        }
        if (j>numCases) break;
    }
}

void drawAxes()
{
    line(axesOffsetX, axesOffsetY+axesHeight, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
    line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight);
}

void drawLabels()
{
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
}
                
void draw()
{
    fill(black);
    stroke(black);
    smooth(); //nothing's changing much, so might as well...
    background(bg); //clears screen
    drawAxes();
    plot();
    drawLabels();
    detailsOnDemand();
    //text(uniqueCountries[uniqueCountries.length-1][0], 10, 10); //testing
}


