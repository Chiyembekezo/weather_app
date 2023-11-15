import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/cubit/counter_cubit_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubitCubit>(
      create: (context) => CounterCubitCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: BlocListener<CounterCubitCubit, CounterCubitState>(
          listener: (context, state) {
            if (state.wasIncremented == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Yay! A SnackBar!'),
                  duration: Duration(microseconds: 300),
                ),
              );
          } else if (state.wasIncremented == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Decremented!'),
                      duration: Duration(microseconds: 300),
                  ),
              );
            }
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed this button this many time'),
                const SizedBox(
                  height: 25,
                ),
                BlocBuilder<CounterCubitCubit, CounterCubitState>(
                  builder: (context, state) {
                    if (state.counterValue < 0) {
                      return Text(
                        'BBR, NEGATIVE' + state.counterValue.toString(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      );
                    }
                    else if (state.counterValue % 2 == 0) {
                      return Text(
                        'YAAAY' + state.counterValue.toString(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      );
                    }
                    else if (state.counterValue == 5) {
                      return Text(
                        'HMM, NUMBER 5' + state.counterValue.toString(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        BlocProvider.of<CounterCubitCubit>(context).decrement();
                      },
                      tooltip: 'Decrease',
                      child: Icon(Icons.remove),
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
                )
              ],
            ),
          );

        }),
    );
  }
}
