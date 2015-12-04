class Edge {
  Node from; 
  Node to; 
  float minutes;
  color col;
  
  Edge(Node from, Node to, color col, float minutes) {
    this.from = from; 
    this.to = to; 
    this.minutes = minutes;
    this.col = col;
  }
  
  Edge(){
  }
  
  Node getFromNode() {
    return from;
  }
  
  Node getToNode() {
    return to;
  }
  
  float getMinutes() {
    return minutes;
  }
  
  void draw() {
    stroke(col); 
    strokeWeight(2);
    line(from.x, from.y, to.x, to.y);
  }
}  