import 'package:flutter/cupertino.dart';
import 'package:sa_lr1_app/pages/result_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  int rowCount = 2;
  int columnCount = 3;
  List<List<int>> tableData = [[]];
  List<List<TextEditingController>> controllers = [[]];

  @override
  void initState() {
    super.initState();
    _initializeTable();
  }

  void _initializeTable() {
    //tableData.clear();
    List<List<int>> newData = [];
    for (int i = 0; i < tableData.length; i++) {
      List<int> row = [];
      for (int j = 1; j <= tableData[i].length; j++) {
        int value;
        try {
          value = int.parse(controllers[i][j].text);
        } catch (e) {
          value = -1;
        }

        row.add(value);
      }
      newData.add(row);
    }
    setState(() {
      tableData = newData;
    });

    int n1 = tableData.length;
    if (n1 < rowCount) {
      for (int i = 0; i < rowCount - n1; i++) {
        List<int> row = <int>[-1];
        tableData.add(row);
      }
    } else {
      for (int i = 0; i < n1 - rowCount; i++) {
        tableData.removeLast();
      }
    }
    for (int i = 0; i < rowCount; i++) {
      int n2 = tableData[i].length;
      if (n2 < columnCount) {
        for (int j = 0; j < columnCount - n2; j++) {
          tableData[i].add(-1);
        }
      } else {
        for (int j = 0; j < n2 - columnCount; j++) {
          tableData[i].removeLast();
        }
      }
    }

    _initializeControllers();
  }

  void _initializeControllers() {
    controllers.clear();
    for (int i = 0; i < rowCount; i++) {
      List<TextEditingController> rowControllers = [];
      TextEditingController controller = TextEditingController();
      controller.text = (i + 1).toString();
      rowControllers.add(controller);
      for (int j = 0; j < columnCount - 1; j++) {
        TextEditingController controller = TextEditingController();
        if (tableData[i][j] == -1) {
          controller.text = '';
        } else {
          controller.text = tableData[i][j].toString();
        }

        rowControllers.add(controller);
      }
      controllers.add(rowControllers);
    }
  }

  void _saveTableData() {
    List<List<int>> newData = [];
    for (int i = 0; i < rowCount; i++) {
      List<int> row = [];
      for (int j = 1; j < columnCount; j++) {
        int value = -1;
        if (controllers[i][j].text != '') {
          value = int.parse(controllers[i][j].text);
        }
        row.add(value);
      }
      newData.add(row);
    }
    setState(() {
      tableData = newData;
    });
    _compute(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Матрица расстояний'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Вершин: '),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: rowCount,
                  onChanged: (value) {
                    setState(() {
                      rowCount = value!;
                      columnCount = value + 1;
                      _initializeTable();
                    });
                  },
                  items: List.generate(20, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text('${index}'),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DataTable(
                    horizontalMargin: 0,
                    columnSpacing: 0,
                    columns: collumns(columnCount),
                    rows: List.generate(rowCount, (i) {
                      return DataRow(
                        cells: List.generate(columnCount, (j) {
                          return DataCell(
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 16) /
                                  (columnCount),
                              child: Center(
                                child: TextField(
                                  controller: controllers[i][j],
                                  decoration: const InputDecoration(
                                    //border: OutlineInputBorder(),
                                    hintText: '-',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTableData,
              child: const Text('Выполнить'),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> collumns(int count) {
    List<DataColumn> collumns_list = [];
    collumns_list.add(const DataColumn(label: Text('')));
    for (int i = 1; i < columnCount; i++) {
      collumns_list.add(DataColumn(label: Text((i).toString())));
    }

    //${String.fromCharCode(97 + index).toUpperCase()}
    return collumns_list;
  }

  List<DataCell> cells(int i, int count) {
    List<DataCell> cells_list = <DataCell>[const DataCell(Text(' '))];

    for (int j = 0; j < count; j++) {
      cells_list.add(DataCell(
        SizedBox(
          width: (MediaQuery.of(context).size.width - 16) / columnCount,
          child: Center(
            child: TextField(
              controller: controllers[i][j],
              decoration: const InputDecoration(),
            ),
          ),
        ),
      ));
    }
    return cells_list;
  }

  List<int> stringToList(String input) {
    List<String> numbersAsString = input.split(' ');
    List<int> numbers = numbersAsString.map((str) => int.parse(str)).toList();
    return numbers;
  }

  List<List<int>> getIncidenceMatrix(List<List<int>> ListOfincidence) {
    int arc_count = 0;

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        arc_count += 1;
      }
    }

    List<List<int>> IncidenceMatrix = List.generate(
        ListOfincidence.length, (_) => List<int>.filled(arc_count, 0));

    int arc_num = 0;

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        if (ListOfincidence[j][i] < ListOfincidence.length) {
          IncidenceMatrix[ListOfincidence[j][i]][arc_num] = -1;
          IncidenceMatrix[j][arc_num] = 1;
          if (ListOfincidence[j][i] == j) {
            IncidenceMatrix[j][arc_num] = 2;
          }
          arc_num += 1;
        }
      }
    }
    return IncidenceMatrix;
  }

  List<List<int>> getListOfincidence_r(List<List<int>> incidence_matrix) {
    List<List<int>> ListOfincidence =
        List.generate(incidence_matrix.length, (_) => <int>[]);

    for (int j = 0; j < incidence_matrix[0].length; j++) {
      for (int i = 0; i < incidence_matrix.length; i++) {
        if (incidence_matrix[i][j] == 1) {
          for (int k = 0; k < incidence_matrix.length; k++) {
            if (incidence_matrix[k][j] == -1) {
              ListOfincidence[i].add(k);
              break;
            }
          }
        }
        if (incidence_matrix[i][j] == 2) {
          ListOfincidence[i].add(i);
        }
      }
    }

    if (ListOfincidence.isEmpty) print('suka pustoy spisok');

    return ListOfincidence;
  }

  List<List<int>> getListOfincidence_l(List<List<int>> incidence_matrix) {
    List<List<int>> ListOfincidence =
        List.generate(incidence_matrix.length, (_) => <int>[]);

    for (int j = 0; j < incidence_matrix[0].length; j++) {
      for (int i = 0; i < incidence_matrix.length; i++) {
        if (incidence_matrix[i][j] == -1) {
          for (int k = 0; k < incidence_matrix.length; k++) {
            if (incidence_matrix[k][j] == 1) {
              ListOfincidence[i].add(k);
              break;
            }
          }
        }
        if (incidence_matrix[i][j] == 2) {
          ListOfincidence[i].add(i);
        }
      }
    }

    if (ListOfincidence.isEmpty) print('suka pustoy spisok');

    return ListOfincidence;
  }

  List<List<int>> getAdjacencyMatrix(List<List<int>> ListOfincidence) {
    List<List<int>> AdjacencyMatrix = List.generate(ListOfincidence.length,
        (_) => List<int>.filled(ListOfincidence.length, 0));

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        if (ListOfincidence[j][i] < ListOfincidence.length)
          AdjacencyMatrix[j][ListOfincidence[j][i]] = 1;
      }
    }

    return AdjacencyMatrix;
  }

  List<List<int>> swap(
      List<List<int>> matrix, List<int> position, int a, int b) {
    int n = matrix.length;
    int bufer;
    for (int i = 0; i < n; i++) {
      bufer = matrix[i][a];
      matrix[i][a] = matrix[i][b];
      matrix[i][b] = bufer;
    }
    for (int i = 0; i < n; i++) {
      bufer = matrix[a][i];
      matrix[a][i] = matrix[b][i];
      matrix[b][i] = bufer;
    }
    bufer = position[a];
    position[a] = position[b];
    position[b] = bufer;

    return matrix;
  }

  List<int> getRenames(List<List<int>> AdjacencyMatrix) {
    List<int> sums = List<int>.filled(AdjacencyMatrix.length, 0);
    List<int> renamed = [];
    List<int> last_renamed = [];
    List<int> rename = List<int>.filled(AdjacencyMatrix.length, 0);
    int n = AdjacencyMatrix.length;

    for (int j = 0; j < n; j++) {
      for (int i = 0; i < n; i++) {
        sums[j] += AdjacencyMatrix[i][j];
      }
    }

    //print(sums);

    int k = 0;

    while (k < n) {
      int flag = -1;

      for (int j = 0; j < n; j++) {
        if (sums[j] == 0 && !renamed.contains(j)) {
          rename[k] = j;
          renamed.add(j);
          last_renamed.add(j);
          flag = 1;
          k += 1;
        }
      }

      if (flag == -1) {
        print('Невозможно выполнить');
        return rename;
      }

      for (int i = 0; i < last_renamed.length; i++) {
        for (int j = 0; j < n; j++) {
          sums[j] -= AdjacencyMatrix[last_renamed[i]][j];
        }
      }

      last_renamed = [];

      //print(sums);
    }
    return rename;
  }

  List<List<int>> orderFunction(List<List<int>> AdjacencyMatrix) {
    List<int> rename = getRenames(AdjacencyMatrix);
    int n = AdjacencyMatrix.length;

    List<int> position = [];
    for (int i = 0; i < n; i++) {
      position.add(i);
    }

    for (int i = 0; i < n; i++) {
      if (position[i] != rename[i]) {
        swap(AdjacencyMatrix, position, position.indexOf(rename[i]), i);
      }
    }

    return AdjacencyMatrix;
  }

  List<int> getReachableSet(
      int point, List<List<int>> listOfincidence_r, List<int> reachable_set) {
    if (reachable_set.contains(point)) return reachable_set;
    reachable_set.add(point);
    for (int i = 0; i < listOfincidence_r[point].length; i++) {
      List<int> bufer = getReachableSet(
          listOfincidence_r[point][i], listOfincidence_r, reachable_set);
      for (int j = 0; j < bufer.length; j++) {
        if (!reachable_set.contains(bufer[j])) reachable_set.add(bufer[j]);
      }
    }
    return reachable_set;
  }

  List<int> intersection(List<int> a, List<int> b) {
    List<int> intersected_set = [];
    for (int i = 0; i < a.length; i++) {
      if (b.contains(a[i])) {
        intersected_set.add(a[i]);
      }
    }
    return intersected_set;
  }

  List<List<int>> getMatrixOfIncidence_new(List<List<int>> subgraphs) {
    List<int> arc_num = [];
    List<List<int>> vershiny_v_duge =
        List.generate(tableData[0].length - 1, (_) => <int>[]);
    for (int i = 0; i < tableData[0].length - 1; i++) {
      for (int j = 0; j < tableData.length; j++) {
        if (tableData[j][i] == 1) {
          vershiny_v_duge[i].add(j);
        }
      }
    }
    for (int i = 0; i < tableData[0].length - 1; i++) {
      for (int j = 0; j < tableData.length; j++) {
        if (tableData[j][i] == -1) {
          vershiny_v_duge[i].add(j);
        }
      }
    }
    for (int i = 0; i < vershiny_v_duge.length; i++) {
      int flag = 0;
      for (int c = 0; c < subgraphs.length; c++) {
        if (subgraphs[c].contains(vershiny_v_duge[i][0]) &&
            subgraphs[c].contains(vershiny_v_duge[i][1])) {
          flag = 1;
        }
      }
      if (flag == 0) {
        arc_num.add(i);
      }
    }

    List<List<int>> matrixOfIncidence_new = List.generate(
        subgraphs.length, (_) => List<int>.filled(arc_num.length, 0));

    for (int i = 0; i < arc_num.length; i++) {
      int start = 0;
      int end = 0;
      for (int c = 0; c < subgraphs.length; c++) {
        if (subgraphs[c].contains(vershiny_v_duge[arc_num[i]][0])) {
          start = c;
        }
      }
      for (int c = 0; c < subgraphs.length; c++) {
        if (subgraphs[c].contains(vershiny_v_duge[arc_num[i]][1])) {
          end = c;
        }
      }
      matrixOfIncidence_new[start][i] = 1;
      matrixOfIncidence_new[end][i] = -1;
    }
    return matrixOfIncidence_new;
  }

  List<List<int>> getListOfincidence_l_from_adjacencyMatrix(
      List<List<int>> adjacencyMatrix) {
    List<List<int>> ListOfincidence =
        List.generate(adjacencyMatrix.length, (_) => <int>[]);

    for (int j = 0; j < adjacencyMatrix.length; j++) {
      for (int i = 0; i < adjacencyMatrix.length; i++) {
        if (adjacencyMatrix[i][j] == 1) {
          ListOfincidence[j].add(i);
        }
      }
    }

    if (ListOfincidence.isEmpty) print('suka pustoy spisok');

    return ListOfincidence;
  }

  List<List<int>> PRIMA() {
    List<bool> selected = List.generate(rowCount, (index) => false);
    List<List<int>> minimal_graph =
        List.generate(rowCount, (_) => List.generate(rowCount, (_) => -1));
    List<List<int>> matrix_of_minimal_way =
        List.generate(rowCount, (_) => List.generate(rowCount, (_) => -1));

    for (int mark = 0; mark < rowCount; mark++) {
      print('Минимальное остовное дерево из вершины ${mark + 1}');
      selected[mark] = true;

      int x; //  row number
      int y; //  col number

      for (int arc_number = 0; arc_number < rowCount; arc_number++) {
        int min = 10000000;
        x = 0;
        y = 0;

        for (int i = 0; i < rowCount; i++) {
          if (selected[i]) {
            for (int j = 0; j < rowCount; j++) {
              if (!selected[j] && tableData[i][j] != -1) {
                //выбираем новую дугу для добавления
                if (min > tableData[i][j]) {
                  min = tableData[i][j];
                  x = i;
                  y = j;
                }
              }
            }
          }
        }
        minimal_graph[x][y] = tableData[x][y];
        print('${x + 1} - ${y + 1} : ${tableData[x][y]}'); //добавляем
        selected[y] = true;
      }
      print('\nПолченная строка матрицы минимальных расстояний');
      matrix_of_minimal_way[mark][mark] = 0;

      for (int c = 0; c < rowCount; c++) {
        for (int i = 0; i < rowCount; i++) {
          if (matrix_of_minimal_way[mark][i] != -1) {
            for (int j = 0; j < rowCount; j++) {
              if (minimal_graph[i][j] != -1) {
                matrix_of_minimal_way[mark][j] =
                    matrix_of_minimal_way[mark][i] + minimal_graph[i][j];
                //ищем расстояние от начальной вершины до остальных
              }
            }
          }
        }
      }
      for (int i = 0; i < rowCount; i++) {
        print(
            '${matrix_of_minimal_way[mark][i]} '); //обнуляем всё что обнуляется и разговариваем
        selected[i] = false;
        for (int j = 0; j < rowCount; j++) {
          minimal_graph[i][j] = -1;
        }
      }
    }
    return matrix_of_minimal_way;
  }

  List<List<int>> getAdjacencyMatrixFromLenghtMatrix() {
    List<List<int>> AdjacencyMatrix = List.generate(
        tableData.length, (_) => List<int>.filled(tableData.length, 0));

    for (int j = 0; j < tableData.length; j++) {
      for (int i = 0; i < tableData.length; i++) {
        if (tableData[i][j] != -1) {
          AdjacencyMatrix[i][j] = tableData[i][j];
        }
      }
    }

    return AdjacencyMatrix;
  }

  void _compute(BuildContext context) {
    try {
      List<List<int>> adjacencyMatrix = getAdjacencyMatrixFromLenghtMatrix();
      List<List<int>> minimalLenghtMatrix = PRIMA();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultPage(
            adjacencyMatrix: adjacencyMatrix,
            minimalLenghtMatrix: minimalLenghtMatrix,
          ),
        ),
      );
    } catch (e) {}
  }
}
