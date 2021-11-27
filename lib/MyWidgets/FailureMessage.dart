
import 'package:flutter/material.dart';

class FailureMessage extends StatelessWidget {
  String message;
  var onRetry;

  FailureMessage({required this.message,this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
         Image.asset("assets/images/warning.png",height: 150,width: 150,),
          SizedBox(
            height: 16,
          ),
          Text(
            message,
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          SizedBox(
            height: 16,
          ),
          if(onRetry!=null)
            ElevatedButton(
                onPressed: onRetry,
                child: Text(
                  "Retry",
                  style: TextStyle(fontSize: 16),
                ))
        ],
      ),
    );
  }
}