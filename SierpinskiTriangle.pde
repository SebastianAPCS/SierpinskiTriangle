// Initial declarations

Matrix3 transform;
float[] angles = new float[2];

int r;
int g;
int b;

double s = 1.5;
float weight = 1;

// Required functions for processing

void setup() {
  size(800, 600);
  strokeWeight(weight);
  
  angles[0] = 45;
  angles[1] = 45;
  
  updateTransform();
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  
  float angle = radians(angles[0]);
  
  if (!mousePressed) {
    angles[0] ++;
    angles[1] ++;
    updateTransform();
  }
  
  r = (int) (127 + 127 * cos(angle));
  g = (int) (127 + 127 * cos(angle + TWO_PI / 3));
  b = (int) (127 + 127 * cos(angle + 2 * TWO_PI / 3));
  
  renderSierpinski(5, 0,
    new Vertex(100 * s, 100 * s, 100 * s),
    new Vertex(-100 * s, -100 * s, 100 * s),
    new Vertex(-100 * s, 100 * s, -100 * s),
    new Vertex(100 * s, -100 * s, -100 * s),
    r, g, b
  );
}

void mouseDragged() {
  float sensitivity = 0.33;
  float yIncrement = sensitivity * (pmouseY - mouseY);
  float xIncrement = sensitivity * (mouseX - pmouseX);
  
  angles[0] += xIncrement;
  angles[1] += yIncrement;
  
  redraw();
  updateTransform();
}

// Define classes for respective objects used for rendering

class Vertex {
  double x;
  double y;
  double z;
  
  Vertex(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Triangle {
  Vertex v1;
  Vertex v2;
  Vertex v3;
  
  Triangle(Vertex v1, Vertex v2, Vertex v3) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }
}

// Render a set of triangles

void renderTriangle(ArrayList<Triangle> tr, int rc, int bc, int gc) {
  for (Triangle triangle : tr) {
    Vertex v1 = transform.transform(triangle.v1);
    Vertex v2 = transform.transform(triangle.v2);
    Vertex v3 = transform.transform(triangle.v3);
    
    stroke(rc, bc, gc);
    
    line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
    line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
    line((float) v3.x, (float) v3.y, (float) v1.x, (float) v1.y);
  }
}

// Render 3D sierpinski triangle

void renderSierpinski(int limit, int count, Vertex v1, Vertex v2, Vertex v3, Vertex v4, int rc, int bc, int gc) {
  if (count >= limit) return;
  
  ArrayList<Triangle> triangle = new ArrayList<Triangle>();
  
  triangle.add(new Triangle(v1, v2, v3));
  triangle.add(new Triangle(v1, v2, v4));
  triangle.add(new Triangle(v3, v4, v1));
  triangle.add(new Triangle(v3, v4, v2));
  
  renderTriangle(triangle, rc, bc, gc);

  renderSierpinski(limit, count + 1,
    v1,
    new Vertex((v1.x + v2.x) / 2, (v1.y + v2.y) / 2, (v1.z + v2.z) / 2),
    new Vertex((v1.x + v3.x) / 2, (v1.y + v3.y) / 2, (v1.z + v3.z) / 2),
    new Vertex((v1.x + v4.x) / 2, (v1.y + v4.y) / 2, (v1.z + v4.z) / 2),
    rc, bc, gc
  );
  
  renderSierpinski(limit, count + 1,
    new Vertex((v1.x + v2.x) / 2, (v1.y + v2.y) / 2, (v1.z + v2.z) / 2),
    v2,
    new Vertex((v2.x + v3.x) / 2, (v2.y + v3.y) / 2, (v2.z + v3.z) / 2),
    new Vertex((v2.x + v4.x) / 2, (v2.y + v4.y) / 2, (v2.z + v4.z) / 2),
    rc, bc, gc
  );
  
  renderSierpinski(limit, count + 1,
    new Vertex((v1.x + v3.x) / 2, (v1.y + v3.y) / 2, (v1.z + v3.z) / 2),
    new Vertex((v2.x + v3.x) / 2, (v2.y + v3.y) / 2, (v2.z + v3.z) / 2),
    v3,
    new Vertex((v3.x + v4.x) / 2, (v3.y + v4.y) / 2, (v3.z + v4.z) / 2),
    rc, bc, gc
  );
  
  renderSierpinski(limit, count + 1,
    new Vertex((v1.x + v4.x) / 2, (v1.y + v4.y) / 2, (v1.z + v4.z) / 2),
    new Vertex((v2.x + v4.x) / 2, (v2.y + v4.y) / 2, (v2.z + v4.z) / 2),
    new Vertex((v3.x + v4.x) / 2, (v3.y + v4.y) / 2, (v3.z + v4.z) / 2),
    v4,
    rc, bc, gc
  );
}

// Update Transform

void updateTransform() {
  float heading = radians(angles[0]);
  float pitch = radians(angles[1]);
  
  Matrix3 headingTransform = new Matrix3(new double[]{
    cos(heading), 0, -sin(heading),
    0, 1, 0,
    sin(heading), 0, cos(heading)
  });
  
  Matrix3 pitchTransform = new Matrix3(new double[]{
    1, 0, 0,
    0, cos(pitch), sin(pitch),
    0, -sin(pitch), cos(pitch)
  });
  
  transform = headingTransform.multiply(pitchTransform);
}

// 3D Matrix class

class Matrix3 {
    double[] values;
    
    Matrix3(double[] values) {
        this.values = values;
    }
    
    Matrix3 multiply(Matrix3 other) {
        double[] result = new double[9];
        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 3; col++) {
                for (int i = 0; i < 3; i++) {
                    result[row * 3 + col] +=
                        this.values[row * 3 + i] * other.values[i * 3 + col];
                }
            }
        }
        return new Matrix3(result);
    }
    
    Vertex transform(Vertex vinput) {
        return new Vertex(
            vinput.x * values[0] + vinput.y * values[3] + vinput.z * values[6],
            vinput.x * values[1] + vinput.y * values[4] + vinput.z * values[7],
            vinput.x * values[2] + vinput.y * values[5] + vinput.z * values[8]
        );
    }
}
