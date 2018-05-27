import 'dart:html';

/**
 * This class visualizes the game
 */

class View {

  /**
   * list of image-paths
   */
  List<List<String>> images;

  /**
   * Basic constructor
   */
  View(List<List<String>> imageList){

    images = imageList;
  }

  /**
   * Generates a HTML-Table from the given Field
   */
  String toHtmlTable(List<List> rows) {
    final table = rows.map((row) {
      final zeile = row.map((col) {
       for(int i=0;i<images.length;i++){
         if(images[i][0]==col.toString()){
           return "<td><img src=""Resources/"+images[i][1]+"></td>";
         }else if(col.toString()==""){
           return "<td></td>";
         }
       }
      }).join();
      return "<tr>$zeile</tr>\n";
    }).join();
    return "<table>\n$table</table>";
  }

  /**
   * updates the hole Field
   */
  void updateField(List<List<String>> content) {
    querySelector('#output').innerHtml = toHtmlTable(content);
  }
}
