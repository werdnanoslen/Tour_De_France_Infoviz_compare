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
    //sortByValue(winCounts);

    minWinsSelected = minWins;
    maxWinsSelected = maxWins;
    
    controlP5 = new ControlP5(this);
    minWinsList = controlP5.addDropdownList("minWinsSelected",axesOffsetX,axesOffsetY+axesHeight+30,70,120);
        minWinsList.captionLabel().set("Select Min");
        minWinsList.captionLabel().style().marginTop = 1;
        minWinsList.setBarHeight(11);
        for (int i=minWins; i<maxWins; ++i)
        {
            minWinsList.addItem(str(i), i);
        }
    maxWinsList = controlP5.addDropdownList("maxWinsSelected",axesOffsetX+axesWidth-70,axesOffsetY+axesHeight+30,70,120);
        maxWinsList.captionLabel().set("Select Max");
        maxWinsList.captionLabel().style().marginTop = 1;
        maxWinsList.setBarHeight(11);
        for (int i=minWins; i<maxWins; ++i)
        {
            maxWinsList.addItem(str(i), i);
        }
}

/*// BEGIN UNORIGINAL CODE
// The following method was taken from http://stackoverflow.com/a/109389
static Map sortByValue(Map map) 
{
     List list = new LinkedList(map.entrySet());
     Collections.sort(list, new Comparator() 
     {
          public int compare(Object o1, Object o2) 
          {
               return ((Comparable) ((Map.Entry) (o1)).getValue())
              .compareTo(((Map.Entry) (o2)).getValue());
          }
     });

    Map result = new LinkedHashMap();
    for (Iterator it = list.iterator(); it.hasNext();) 
    {
        Map.Entry entry = (Map.Entry)it.next();
        result.put(entry.getKey(), entry.getValue());
    }
    return result;
} 

// The following method was taken from http://stackoverflow.com/a/2904266
static <T, E> Set<T> getKeysByValue(Map<T, E> map, E value) {
     Set<T> keys = new HashSet<T>();
     for (MyEntry<T, E> entry : map.entrySet()) {
         if (value.equals(entry.getValue())) {
             keys.add(entry.getKey());
         }
     }
     return keys;
}
// END UNORIGINAL CODE*/

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
    for (int i=0; i<numCases; ++i)
    {
        text("Belgium"/*winCounts.firstKey()*/, axesOffsetX-20, axesOffsetY+30+barOffset*i);
        rect(axesOffsetX, axesOffsetY+50+barOffset*i, 10/*winCounts.get(winCounts.firstKey())*/, -40);
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
}


