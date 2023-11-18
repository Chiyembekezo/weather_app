import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../business_logic/cubit/counter_cubit_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title, this.color}) : super(key: key);

  String? title;
  Color? color;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed this button this many time'),
            BlocConsumer<CounterCubitCubit, CounterCubitState>(
              listener: (context, state) {
                if (state.wasIncremented == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yay! A SnackBar!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                } else if (state.wasIncremented == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Decremented!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.counterValue < 0) {
                  return Text(
                    'BBR, NEGATIVE${state.counterValue}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                }
                else if (state.counterValue % 2 == 0) {
                  return Text(
                    'YAAAY${state.counterValue}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                }
                else if (state.counterValue == 5) {
                  return Text(
                    'HMM, NUMBER 5${state.counterValue}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                } else
                  return Text(
                    state.counterValue.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<CounterCubitCubit>(context).decrement();
                  },
                  tooltip: 'Decrease',
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<CounterCubitCubit>(context).increment();
                  },
                  tooltip: 'Increase',
                  child: const Icon(
                    Icons.add,
                    color: Color(0xff8DC63F),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            MaterialButton(onPressed: () {}, child: Text('Next Screen', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),)
          ],
        ),
      ),
    );
  }
}