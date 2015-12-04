import processing.pdf.*; //<>//

Table locations; 
Table connections; 

// nodes
int nodeCount; 
Node[] nodes = new Node[150];
HashMap nodeTable = new HashMap();
Node selection = new Node("", 0.0, 0.0, -1);

// edges
int edgeCount; 
Edge[] edges = new Edge[500];

int currentRow = -1; 
PrintWriter writer; 

// font
PFont font; 

// record
boolean record; 

//active stuff
boolean[] activeNodes;
boolean[] activeEdges;

//shortest path
Node A = new Node("", 0.0, 0.0, -1);

Node B = new Node("", 0.0, 0.0, -1);


int numOfNodes;
float numOfMinutes = 0.0;


void setup() {
  size(559, 559);
  font = createFont("SansSerif", 10);
  locations = new Table("locations.csv"); 
  connections = new Table("connections.csv");  
  loadData();
  initializeActiveDataStructures();
  initializeAdjacencyMatrix();
}

void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }

  textFont(font); 
  smooth();

  background(255); 

  if (numOfMinutes == 0.0) {
    // draw the edges
    for (int i = 0; i < edgeCount; i++) {
      edges[i].draw();
    }

    // draw the nodes
    for (int i = 0; i < nodeCount; i++) {

      nodes[i].draw();
    }
  } else {
    for (int i = 0; i < activeEdges.length; i++) {
      System.out.println("It got here");
      if (activeEdges[i] == true) {
        edges[i].draw();
      }
    }

    for (int i = 0; i < activeNodes.length; i++) {
      System.out.println("It got here");
      if (activeNodes[i] == true) {
        nodes[i].draw();
      }
    }
  }

  if (record) {
    endRecord();
    record = false;
  }

  fill(0, 0, 0);
  if (!(selection.label.isEmpty())) {
    text("Station: " + selection.label, 10.0, 10.0);
  };

  if (!(A.label.isEmpty())) {
    text("To: " + A.label, 10.0, 20.0);
  };

  if (!(B.label.isEmpty())) {
    text("From: " + B.label, 10.0, 30.0);
  };

  if (!(numOfMinutes == 0)) {
    text("Minutes: " + numOfMinutes, 10.0, 40.0);
  };
}

void mouseMoved() {
  float closest = 2;
  for (int i = 0; i < nodeCount; i++) {
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if (d < closest) {
      selection = n;
      closest = d;
      fill(0, 0, 0);
      text(selection.label, 10.0, 10.0);
    }
  }
}

void mouseClicked() {
  float closest = 3;
  if (mouseButton == LEFT) {
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        if ((A.label.isEmpty() && B.label.isEmpty())) {
          A = n;
        } else if ((!(A.label.isEmpty()) && B.label.isEmpty())) {
          B = n;
          numOfNodes++;
          float numOfStops = shortestPath(A.getIndex(), B.getIndex());
          numOfMinutes = calculateNumOfMinutes( A, B, numOfStops);
          draw();
        } else if ((!(A.label.isEmpty()) && !(B.label.isEmpty()))) {
          A = n;
          B = new Node("", 0.0, 0.0, -1);
        }
        closest = d;
      }
    }
  } else {
    A = new Node("", 0.0, 0.0, -1);
    B = new Node("", 0.0, 0.0, -1);
    numOfNodes = 0;
    numOfMinutes = 0.0;
  }
}

void loadData() {
  color col;
  for (int i = 1; i < connections.getRowCount(); i++) {
    String fromLabel = connections.getString(i, 0);
    String toLabel = connections.getString(i, 1);
    String colorLabel = connections.getString(i, 2);
    switch(colorLabel) {
    case "red": 
      col = color(230, 19, 16);
      break;
    case "green": 
      col = color(1, 104, 66);
      break;
    case "blue": 
      col = color(0, 48, 140);
      break;
    case "orange": 
      col = color(255, 131, 5);
      break;
    default: 
      col = color(255, 255, 255);
      break;
    }

    float minutes = connections.getFloat(i, 3);
    addEdge(fromLabel, toLabel, col, minutes);
  }
}

void addEdge(String fromLabel, String toLabel, color col, float minutes) {
  // find nodes
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);

  // old edge?
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      return;
    }
  }

  // add edge
  Edge e = new Edge(from, to, col, minutes);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}

Node findNode(String label) {
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}

Node addNode(String label) {
  float x = locations.getFloat(label, 1); 
  float y = locations.getFloat(label, 2); 
  Node n = new Node(label, x, y, nodeCount);
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n;
}

float calculateNumOfMinutes(Node to, Node from, float numOfStops) {
  float totalMinutes = 0.0;
  Edge k = new Edge();
  for (int i = 0; i < edgeCount; i++) {
    k = edges[i];
    if (from.label == k.from.label) {
      Edge origin = k;
    }
  }
  for (int j = 0; j < numOfStops; j++) {
    totalMinutes += k.minutes;
    // find next edge
    for (int i = 0; i < edgeCount; i++) {
      Edge intermidate = edges[i];
      if (k.to == intermidate.from) {
        k = intermidate;
      }
    }
  }
  return totalMinutes;
}